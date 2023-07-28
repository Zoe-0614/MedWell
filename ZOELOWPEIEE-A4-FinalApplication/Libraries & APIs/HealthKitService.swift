//
//  HealthKitService.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 24/05/2023.
//

import Foundation
import HealthKit

/// Possible errors that can occur in the HealthKit service.
enum HealthKitError: Error {
    case deviceNotCompatible(description: String?)
    case notAuthorized(description: String)
    case healthTypeNotAvailable
    case genericError
}

/// A service class for interacting with HealthKit.
class HealthKitService {
    private static let _shared = HealthKitService()
    private let healthKitStore = HKHealthStore()
    
    /// The shared instance of the HealthKit service.
    static var shared: HealthKitService {
        return self._shared
    }
    
    /// Checks if HealthKit is available on the device.
    private var isHealthKitAvailable: Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        return true
    }
    
    /// Requests authorization for the required HealthKit data types.
    /// - Parameter handler: A closure to handle the authorization result or error.
    func requestDataTypes(handler: @escaping (_ data: HealthKitError?) -> Void) {
        if self.isHealthKitAvailable {
            guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
            let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
            let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                handler(HealthKitError.healthTypeNotAvailable)
                return
            }
            
            let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth, bloodType, biologicalSex, bodyMassIndex, height, bodyMass, heartRate, stepCount, sleepAnalysis, activeEnergyBurned, .workoutType()]
            
            HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) in
                if error != nil {
                    handler(HealthKitError.genericError)
                    return
                }
                handler(nil)
            }
        } else {
            handler(HealthKitError.deviceNotCompatible(description: "Device not compatible with HealthKit"))
            return
        }
    }
    
    /// Retrieves the user's biological sex.
    /// - Parameter handler: A closure to handle the retrieved biological sex or error.
    func getBiologicalSex(handler: @escaping (_ biologicalSex: HKBiologicalSexObject?, _ error: Error?) -> Void) {
        do {
            let biologicalSex = try self.healthKitStore.biologicalSex()
            handler(biologicalSex, nil)
        } catch {
            handler(nil, error)
        }
    }
    
    /// Retrieves the user's birthday date.
    /// - Parameter handler: A closure to handle the retrieved birthday date or error.
    func getBirthdayDate(handler: @escaping (_ birthDate: Date?, _ error: Error?) -> Void) {
        do {
            let birthdayComponents =  try self.healthKitStore.dateOfBirthComponents()
            let birthDayDate = Calendar.current.date(from: birthdayComponents)
            handler(birthDayDate, nil)
            return
        } catch {
            handler(nil, error)
        }
    }
    
    /// Retrieves the user's blood type.
    /// - Parameter handler: A closure to handle the retrieved blood type or error.
    func getBloodType(handler: @escaping (_ bloodType: HKBloodTypeObject?, _ error: Error?) -> Void) {
        do {
            let bloodType = try self.healthKitStore.bloodType()
            handler(bloodType, nil)
            return
        } catch {
            handler(nil, error)
        }
    }
    
    /// Retrieves the user's sleeping hours..
    /// - Parameter handler: A closure to handle the retrieved sleepAnalysis data or error.
    func getSleepAnalysisData(handler: @escaping (_ samples: [HKSample]?, _ error: Error?) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                handler(nil, error)
                return
            }
            
            if let sleepSamples = samples as? [HKCategorySample] {
                handler(sleepSamples, nil)
            } else {
                handler(nil, HealthKitError.genericError)
            }
        }
        
        healthKitStore.execute(query)
    }
    
    /// Retrieves the user's heart rate.
    /// - Parameter handler: A closure to handle the retrieved heart rate or error.
    func getHeartRateData(handler: @escaping (_ samples: [HKSample]?, _ error: Error?) -> Void) {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                handler(nil, error)
                return
            }
            
            if let heartRateSamples = samples as? [HKQuantitySample] {
                handler(heartRateSamples, nil)
            } else {
                handler(nil, HealthKitError.genericError)
            }
        }
        
        healthKitStore.execute(query)
    }
    
    
    
}
