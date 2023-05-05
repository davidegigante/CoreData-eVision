//
//  SettingView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 05/05/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Notifications")
                    }
                    
                    Toggle(isOn: $darkModeEnabled) {
                        Text("Dark Mode")
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutAppView()) {
                        Text("About The App")
                    }

                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: TermsOfServiceView()) {
                        Text("Terms of Service")
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct AboutAppView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Our app uses the camera to recognize buildings at the University of Salerno. Once a building is identified, the app displays the availability of classrooms and, if available, the schedule for each room.")
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .navigationTitle("About the app")
            .padding(.horizontal)
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("1. Introduction")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Welcome to our app! Your privacy is important to us, and we are committed to protecting your personal information. This Privacy Policy outlines the types of information we collect, how we use that information, and the measures we take to safeguard it.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("2. What we collect")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("We does not collect any tyoe of information, such as your device's camera data, to recognize university buildings and provide you with the corresponding room availability and schedules.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("3. Sharing your information")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("We do not sell, rent, or share your personal information with third parties without your consent, except when required by law or to protect the rights, property, or safety of our users or the public.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("4. Changes to the privacy policy")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("We may update this Privacy Policy from time to time. We encourage you to review it periodically to stay informed about our privacy practices.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("5. Contact information")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("If you have any questions or concerns about this Privacy Policy, please contact us at d.gigante2@studenti.unisa.it.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .navigationTitle("Privacy Policy")
            .padding(.horizontal)
        }
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("1. Introduction")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Welcome to our app! By using our services, you agree to be bound by these Terms of Service. Please read them carefully before using our app.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("2. User conduct and acceptable use")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("You agree to use our app responsibly and legally. You may not use our services for any unlawful purposes, engage in any activity that disrupts our services, or violate any third-party rights.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("3. Intellectual property rights")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("We retain all rights, title, and interest in and to our app and its content. Unauthorized use of our intellectual property is strictly prohibited.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("4. Disclaimer of warranties and limitation of liability")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Our app is provided \"as is\" and \"as available\" without any warranties, either express or implied. We are not liable for any damages arising from your use of our services.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("5. Indemnification")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("You agree to indemnify and hold us harmless from any claims, damages, losses, or expenses resulting from your violation of these Terms of Service or your use of our app.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            .navigationTitle("Privacy Policy")
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 16) {
                
                Text("6. Termination")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("We reserve the right to terminate your access to our services at any time, with or without notice, for any reason.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("7. Governing law and jurisdiction")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("These Terms of Service shall be governed by and construed in accordance with the laws of Italy. Any disputes arising from these terms shall be subject to the exclusive jurisdiction of the courts of Italy.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("8. Changes to the terms of service")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("We may modify these Terms of Service from time to time. By continuing to use our services, you agree to be bound by the updated terms.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("9. Contact information")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("If you have any questions or concerns about this Privacy Policy, please contact us at d.gigante2@studenti.unisa.it.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
