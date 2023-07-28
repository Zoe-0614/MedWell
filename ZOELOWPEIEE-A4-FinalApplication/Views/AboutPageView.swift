//
//  AboutPageView.swift
//  ZOELOWPEIEE-A4-FinalApplication
//
//  Created by Zoe Low on 08/06/2023.
//

import SwiftUI

// The view acknowledging all 3rd party libraries and API used, and referencing tutorials online followed to aid development in this project.
struct AboutPageView: View {
    var body: some View {
    Text("About Page")
        .font(.title)
            Form {
                // This section contains the libraries used in this app
                Section(header: Text("Libraries:")
                    .font(.headline)) {
                        Text("- Firebase: https://github.com/firebase/firebase-ios-sdk")
                        Text("- MessageKit: https://github.com/MessageKit/MessageKit")
                        Text("- HealthKit: https://developer.apple.com/documentation/healthkit")
                        Text("- Charts: https://github.com/danielgindi/Charts")
                        Text("- RealmSwift: https://github.com/realm/realm-cocoa")
                    }
                    .padding(5)
                
                // This section contains the API used in this app
                Section(header: Text("API:")
                    .font(.headline)) {
                        Text("API source link: https://currentsapi.services/api/docs/ (To get the latest news related to the Health category)")
                        Text("Username: ZoeLow")
                        Text("Email: zlow0011@student.monash.edu")
                        Text("API Token: Rv25whPKOaWA7_m1Y5YkxDROkRBYwMrl8-jrbsJkCFNXg9eF")
                    }
                    .padding(5)
                
                // This section contains the tutorials reffered while implementing this app
                Section(header: Text("References:")
                    .font(.headline)) {
                        Text("1. iOS Academy. (2021, January 26). Swift To Do List App for Beginners (Make First App, Xcode 14, 2023, iOS) - Swift 5[Video]. YouTube. https://www.youtube.com/watch?v=Vqo36o9fSMM")
                        Text("2. SwiftUI Basics Tutorial. (n.d.). Www.youtube.com. https://www.youtube.com/watch?v=HXoVSbwWUIk")
                        Text("3. [Answer]-Query HealthKit for HKCategoryTypeIdentifierSleepAnalysis-swift. (n.d.). Hire Developers, Free Coding Resources for the Developer. Retrieved June 9, 2023, from https://www.appsloveworld.com/swift/100/28/query-healthkit-for-hkcategorytypeidentifiersleepanalysis#:~:text=The%20method%20to%20query%20for%20sleep%20data%20looks")
                        Text("4. Reading data from HealthKit. (n.d.). Apple Developer Documentation. Retrieved June 9, 2023, from https://developer.apple.com/documentation/healthkit/reading_data_from_healthkit#")
                    }
            }
        }
}


struct AboutPageView_Previews: PreviewProvider {
    static var previews: some View {
        AboutPageView()
    }
}
