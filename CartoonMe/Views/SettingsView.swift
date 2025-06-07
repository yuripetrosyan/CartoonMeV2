import SwiftUI

struct SettingsView: View {
    @Binding var hideTabBar: Bool
    @StateObject private var settingsManager = UserSettingsManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showingResetAlert = false
    @State private var showingLanguagePicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.1),
                        Color(red: 0.1, green: 0.1, blue: 0.2),
                        Color(red: 0.15, green: 0.1, blue: 0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("settings.title".localized)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        
                        // Settings Cards
                        LazyVStack(spacing: 16) {
                            // Ads Settings Card
                            SettingsCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Image(systemName: "rectangle.badge.minus")
                                            .font(.title2)
                                            .foregroundColor(.orange)
                                        
                                                                                 Text("settings.advertisements".localized)
                                             .font(.headline)
                                             .fontWeight(.semibold)
                                             .foregroundColor(.white)
                                         
                                         Spacer()
                                     }
                                     
                                     HStack {
                                         VStack(alignment: .leading, spacing: 4) {
                                             Text("settings.disable_ads".localized)
                                                 .font(.subheadline)
                                                 .fontWeight(.medium)
                                                 .foregroundColor(.white)
                                             
                                             Text("settings.disable_ads_description".localized)
                                                 .font(.caption)
                                                 .foregroundColor(.gray)
                                         }
                                        
                                        Spacer()
                                        
                                        Toggle("", isOn: $settingsManager.adsDisabled)
                                            .toggleStyle(ModernToggleStyle())
                                    }
                                }
                            }
                            
                            // Language Settings Card
                            SettingsCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Image(systemName: "globe")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                        
                                        Text("settings.language".localized)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    
                                    Button(action: {
                                        showingLanguagePicker = true
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("settings.select_language".localized)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)
                                                
                                                Text(settingsManager.selectedLanguage.localizedName)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white.opacity(0.05))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                            }
                            
                            // App Info Card
                            SettingsCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                     
                                        
                                                                                  Text("settings.app_info".localized)
                                             .font(.headline)
                                             .fontWeight(.semibold)
                                             .foregroundColor(.white)
                                         
                                         Spacer()
                                     }
                                     
                                     VStack(alignment: .leading, spacing: 12) {
                                         InfoRow(title: "settings.version".localized, value: "1.4.0")
                                         InfoRow(title: "settings.build".localized, value: "1")
                                         InfoRow(title: "settings.developer".localized, value: "yuripetrosyann@gmail.com")
                                     }
                                }
                            }
                            
                            // Reset Settings Card
                            SettingsCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        
                                                                                  Text("settings.reset".localized)
                                             .font(.headline)
                                             .fontWeight(.semibold)
                                             .foregroundColor(.white)
                                         
                                         Spacer()
                                     }
                                     
                                     Button(action: {
                                         showingResetAlert = true
                                     }) {
                                         HStack {
                                             Image(systemName: "arrow.counterclockwise")
                                             Text("settings.reset_all".localized)
                                         }
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.red)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.red.opacity(0.1))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(.red.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100) // Account for tab bar
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            hideTabBar = false
        }
        .alert("settings.reset_alert_title".localized, isPresented: $showingResetAlert) {
            Button("settings.cancel".localized, role: .cancel) { }
            Button("settings.reset".localized, role: .destructive) {
                settingsManager.resetAllSettings()
            }
        } message: {
            Text("settings.reset_alert_message".localized)
        }
        .sheet(isPresented: $showingLanguagePicker) {
            LanguagePickerView(selectedLanguage: $settingsManager.selectedLanguage)
        }
        .onChange(of: settingsManager.selectedLanguage) { _, newLanguage in
            LocalizationManager.shared.setLanguage(newLanguage.code)
        }
    }
}

// MARK: - Supporting Views

struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
    }
}

struct ModernToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? 
                      LinearGradient(colors: [.green, .green.opacity(0.8)], startPoint: .leading, endPoint: .trailing) :
                      LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                .frame(width: 50, height: 28)
                .overlay(
                    Circle()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        .padding(2)
                        .offset(x: configuration.isOn ? 11 : -11)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SettingsView(hideTabBar: .constant(false))
} 
