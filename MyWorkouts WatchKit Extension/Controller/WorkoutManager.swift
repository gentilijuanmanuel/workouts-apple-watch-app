/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The workout manager that interfaces with HealthKit.
*/

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }

    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }

    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?

    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor

        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }

        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self

        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)

        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }

    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the health store.
        var typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .walkingSpeed)!,
            HKObjectType.activitySummaryType()
        ]
        if #available(watchOS 9.0, *) {
            typesToRead.insert(HKQuantityType.quantityType(forIdentifier: .runningSpeed)!)
        }
        if #available(watchOS 10.0, *) {
            typesToRead.insert(HKQuantityType.quantityType(forIdentifier: .cyclingSpeed)!)
            typesToRead.insert(HKQuantityType.quantityType(forIdentifier: .cyclingCadence)!)
        }

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }

    // MARK: - Session State Control

    // The app's workout state.
    @Published var running = false

    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }

    func pause() {
        session?.pause()
    }

    func resume() {
        session?.resume()
    }

    func endWorkout() {
        session?.end()
        showingSummaryView = true
    }

    // MARK: - Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?

    // TODO: figure out a way to expose this only for watchOS 9.0+
    @Published var currentPace: Double = 0
    @Published var averagePace: Double = 0
    @Published var cadence: Double = 0

    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        print("Logging: -> \(statistics.quantityType)")

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
                HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            // TODO: figure out why this quantity type is not being returned.
            case HKQuantityType.quantityType(forIdentifier: .walkingSpeed):
                let paceUnit = HKUnit.meter().unitDivided(by: HKUnit.second())
                self.currentPace = statistics.sumQuantity()?.doubleValue(for: paceUnit) ?? 0
                self.averagePace = statistics.averageQuantity()?.doubleValue(for: paceUnit) ?? 0
            default:
                break
            }

            if #available(watchOS 9.0, *),
               statistics.quantityType == HKQuantityType.quantityType(forIdentifier: .runningSpeed) {
                let paceUnit = HKUnit.meter().unitDivided(by: HKUnit.second())
                self.currentPace = statistics.mostRecentQuantity()?.doubleValue(for: paceUnit) ?? 0
                self.averagePace = statistics.averageQuantity()?.doubleValue(for: paceUnit) ?? 0
            }

            if #available(watchOS 10.0, *) {
                switch statistics.quantityType {
                // TODO: figure out why this quantity type is not being returned.
                case HKQuantityType.quantityType(forIdentifier: .cyclingSpeed):
                    let paceUnit = HKUnit.meter().unitDivided(by: HKUnit.second())
                    self.currentPace = statistics.mostRecentQuantity()?.doubleValue(for: paceUnit) ?? 0
                    self.averagePace = statistics.averageQuantity()?.doubleValue(for: paceUnit) ?? 0
                case HKQuantityType.quantityType(forIdentifier: .cyclingCadence):
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    self.cadence = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                    break
                default:
                    break
                }
            }
        }
    }

    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        workout = nil
        session = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
        currentPace = 0
        averagePace = 0
        cadence = 0
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
