# CartoonMe iOS App

CartoonMe is an iOS SwiftUI app that transforms photos into various cartoon styles using AI image generation.

## 🎨 Features

- Transform photos into 6 different cartoon styles:
  - Studio Ghibli
  - The Simpsons
  - Disney 3D
  - Anime Style
  - Comic Book
  - Realistic Cartoon

- Smart person detection for optimized prompts
- Real-time progress simulation during generation
- In-app image expansion and sharing
- Export functionality with iOS share sheet

## 🚀 Recent Updates

### OpenAI GPT-Image-1 Integration

**Branch:** `experiment-openai-gpt-image-1`

We've successfully implemented OpenAI's newest **`gpt-image-1`** model, which was released in April 2025. This is the same model that powers ChatGPT's image generation capabilities.

#### **The Correct Implementation: gpt-image-1**
- **Model**: `"gpt-image-1"` (OpenAI's latest image generation model)
- **Endpoint**: `/v1/images/generations` (proper image generation endpoint)
- **Input**: Text prompts only (this is a text-to-image model, not image-to-image)
- **Output**: Base64 encoded images in structured JSON format
- **Quality**: Same high-quality results as ChatGPT's interface

#### **How It Works:**
1. **Smart Prompting**: Enhanced prompts optimized for each cartoon style
2. **Person Detection**: Vision framework detects people for better prompt optimization
3. **Style-Specific Parameters**: Each theme (Studio Ghibli, Disney, etc.) has custom prompts
4. **Progress Simulation**: Real-time visual effects during generation
5. **High-Quality Output**: 1024x1024 resolution with excellent detail

#### **Important Note about Structure Preservation:**
The `gpt-image-1` model is a **text-to-image generator**, not an image-to-image transformer. This means:
- ✅ Creates beautiful, high-quality cartoon images
- ✅ Follows style instructions very well  
- ❌ Cannot directly preserve your original photo's structure
- ❌ Creates new compositions based on text descriptions

For **structure-preserving transformations** (like ChatGPT's interface appears to do), you would need image-to-image capabilities that are not yet available via OpenAI's public APIs.

#### **Alternatives for Structure Preservation:**
1. **Stability AI ControlNet** (main branch): ✅ True image-to-image transformation
2. **Wait for OpenAI's Image-to-Image API**: 🕐 Not yet released publicly
3. **Enhanced Prompting**: ⚠️ Describe your photo in detail (current approach)

## 🔧 Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 18.2+ deployment target
- OpenAI API account with access to `gpt-image-1`

### API Configuration

#### For OpenAI GPT-Image-1 (experiment-openai-gpt-image-1 branch):

1. **Get OpenAI API Access:**
   - Create an account at [OpenAI Platform](https://platform.openai.com)
   - Complete identity verification for `gpt-image-1` access
   - Generate an API key from your dashboard

2. **Set Environment Variable:**
   ```bash
   export OPENAI_API_KEY="your-api-key-here"
   ```

3. **Alternative Setup:**
   - Edit `CartoonMe/Services/ImageProcessor.swift`
   - Replace `"YOUR_FALLBACK_API_KEY"` with your actual API key
   - ⚠️ **Note**: This is less secure than environment variables

#### For Stability AI (main branch):

1. **Get Stability AI API Access:**
   - Create account at [Stability AI Platform](https://platform.stability.ai)
   - Generate API key

2. **Set Environment Variable:**
   ```bash
   export STABILITY_API_KEY="your-api-key-here"
   ```

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd CartoonMe
   ```

2. Switch to the OpenAI branch (recommended):
   ```bash
   git checkout experiment-openai-gpt-image-1
   ```

3. Open in Xcode:
   ```bash
   open CartoonMe.xcodeproj
   ```

4. Build and run on your iOS device or simulator

## 📱 Usage

1. **Select a Photo**: Tap the photo placeholder to choose an image from your library
2. **Choose a Style**: Select from the 6 available cartoon styles
3. **Generate**: Tap "Cartoon It!" to start the transformation
4. **View Results**: The generated image appears with progress simulation
5. **Export**: Tap the blue "Export" button to share your cartoon

## 🏗 Technical Architecture

### Core Components

- **ContentView.swift**: Main UI and state management
- **ImageProcessor.swift**: AI API integration and image processing
- **ShareSheet.swift**: iOS share functionality
- **Vision Framework**: Person detection for optimized prompts

### API Integration

#### OpenAI GPT-Image-1 Flow:
1. Image resizing and orientation fixing
2. Person detection using Vision framework  
3. Dynamic prompt generation based on detected content
4. JSON API request to OpenAI's `/images/generations` endpoint
5. Base64 image decoding and display

#### Progress Simulation:
- Real-time visual effects during generation
- Pixelation, blur, and enhancement filters
- Smooth progress from 0% to 100%

## 🔄 Branch Comparison

| Feature | Main Branch (Stability AI) | Experiment Branch (OpenAI) |
|---------|---------------------------|----------------------------|
| **API Provider** | Stability AI ControlNet | OpenAI gpt-image-1 |
| **Request Format** | Multipart form data | JSON payload |
| **Image Quality** | High detail, structural control | Excellent prompt adherence |
| **Speed** | ~30-60 seconds | ~15-30 seconds |
| **Cost** | Variable by resolution | ~1/3 cost of GPT-4 |
| **Text Rendering** | Good | Excellent |
| **Setup Complexity** | Moderate | Simple |

## 🐛 Troubleshooting

### Common Issues:

1. **"Missing API Key" Error:**
   - Ensure your API key is properly set in environment variables
   - Check that the key has proper permissions

2. **"Network Error":**
   - Verify internet connection
   - Check API key validity
   - Ensure account has sufficient credits

3. **"Model Access Error":**
   - Confirm your OpenAI account is verified for `gpt-image-1`
   - Check billing status and usage limits

4. **UIKit Import Error:**
   - This is typically a development environment issue
   - Clean build folder (⌘+Shift+K) and rebuild
   - Restart Xcode if necessary

## 📄 License

This project is available for educational and personal use. Please ensure you comply with the respective AI service terms of use.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review OpenAI's [API documentation](https://platform.openai.com/docs)
3. Open an issue in this repository

---

**Current Version**: 2.0.0-experimental  
**Last Updated**: December 2024  
**iOS Support**: iOS 18.2+

  
