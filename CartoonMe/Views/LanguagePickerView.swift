import SwiftUI

struct LanguagePickerView: View {
    @Binding var selectedLanguage: Language
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Language.supportedLanguages, id: \.code) { language in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(language.localizedName)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(language.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if selectedLanguage.code == language.code {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLanguage = language
                        LocalizationManager.shared.setLanguage(language.code)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    LanguagePickerView(selectedLanguage: .constant(Language.supportedLanguages[0]))
} 