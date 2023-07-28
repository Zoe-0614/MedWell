////
////  HealthKitContentView.swift
////  ZOELOWPEIEE-A4-FinalApplication
////
////  Created by Zoe Low on 24/05/2023.
////
//
//import SwiftUI
//import HealthKit
//
//struct HealthKitContentView: View {
//
//    @EnvironmentObject var healthStore: HKHealthStore
//
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .padding()
//        .onAppear(){
//            readHeartRate()
//            readTotalStepCount()
//            readHourlyTotalStepCount()
//        }
//    }
//
//    //MARK: - Read heart rate
//
//    private func readHeartRate(){
//        let quantityType  = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
//        let sampleQuery = HKSampleQuery.init(sampleType: quantityType,
//                                             predicate: get24hPredicate(),
//                                             limit: HKObjectQueryNoLimit,
//                                             sortDescriptors: [sortDescriptor],
//                                             resultsHandler: { (query, results, error) in
//
//            guard let samples = results as? [HKQuantitySample] else {
//                print(error!)
//                return
//            }
//            for sample in samples {
//                let mSample = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
//                print("Heart rate : \(mSample)")
//            }
//
//        })
//        self.healthStore .execute(sampleQuery)
//
//    }
//
//    func readTotalStepCount() {
//        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
//            fatalError("*** Unable to get the step count type ***")
//        }
//
//        let query = HKStatisticsQuery.init(quantityType: stepCountType,
//                                           quantitySamplePredicate: get24hPredicate(),
//                                           options: [HKStatisticsOptions.cumulativeSum, HKStatisticsOptions.separateBySource]) { (query, results, error) in
//            let totalStepCount = results?.sumQuantity()!.doubleValue(for: HKUnit.count())
//            print("Total step count: \(totalStepCount ?? 0)")
//            if ((results?.sources) != nil){
//                for source in (results?.sources)! {
//                    let separateSourceStepCount = results?.sumQuantity(for: source)!.doubleValue(for: HKUnit.count())
//                    print("Seperate Source total step count: \(separateSourceStepCount ?? 0)")
//                }
//            }
//        }
//
//        healthStore.execute(query)
//    }
//
//    func readHourlyTotalStepCount() {
//        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
//            fatalError("*** Unable to get the step count type ***")
//        }
//
//        var interval = DateComponents()
//        interval.hour = 1
//
//        let calendar = Calendar.current
//        let anchorDate = calendar.date(bySettingHour: 0, minute: 55, second: 0, of: Date())
//
//        let query = HKStatisticsCollectionQuery.init(quantityType: stepCountType,
//                                                     quantitySamplePredicate: nil,
//                                                     options: .cumulativeSum,
//                                                     anchorDate: anchorDate!,
//                                                     intervalComponents: interval)
//
//        query.initialResultsHandler = { query, results, error in
//            let startDate = calendar.date(byAdding: .hour,value: -24, to: Date())
//
//            results?.enumerateStatistics(from: startDate!,to: Date(), with: { (result, stop) in
//                print("Time: \(result.startDate) -\(result.endDate), \(result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0)")
//            })
//        }
//        healthStore.execute(query)
//    }
//
//    private func get24hPredicate() ->  NSPredicate{
//        let today = Date()
//        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: today)
//        let predicate = HKQuery.predicateForSamples(withStart: startDate,end: today,options: [])
//        return predicate
//    }
//}
//
//struct HealthKitContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HealthKitContentView()
//    }
//}
//
//class HealthKitContentViewHostingController: UIHostingController<HealthKitContentView>{
//    required init? (coder: NSCoder){
//        super.init(coder: coder, rootView: HealthKitContentView())
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}
