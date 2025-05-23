# CartoonMe V2 - AI Photo Transformation

Transform your photos into stunning cartoon styles using **OpenAI's GPT-image-1** model! CartoonMe V2 is a completely rewritten iOS SwiftUI app that brings professional-grade AI image transformation to your fingertips.

## ✨ What's New in V2

### 🚀 **OpenAI GPT-image-1 Integration**
- **Latest AI Technology**: Uses OpenAI's newest image generation model (same as ChatGPT)
- **Superior Quality**: Professional-grade cartoon transformations
- **Smart Analysis**: GPT-4o analyzes your photos for optimal style application
- **Privacy-Safe**: Conservative prompts that respect content policies

### 🎨 **7 Cartoon Styles**
Transform photos into:
- **Studio Ghibli** - Dreamy anime watercolor style
- **The Simpsons** - Classic 2D cartoon look
- **Disney 3D** - Modern animated movie style
- **Modern Anime** - Contemporary Japanese animation
- **Comic Book** - Bold comic illustration
- **Semi-Realistic** - Stylized but detailed cartoon
- **Generic Cartoon** - Versatile cartoon style

### 🔧 **Technical Improvements**
- **Two-Step Processing**: Image analysis → Style generation
- **Enhanced Structure Preservation**: Maintains pose, composition, and details
- **Progress Simulation**: Real-time visual effects during generation
- **Moderation Compliant**: Built-in safety measures for content approval
- **Cost Optimized**: Efficient API usage with gpt-4o-mini for analysis

## 📱 Features

### Core Functionality
- **Photo Import**: Camera or photo library
- **Real-time Preview**: Progress simulation with Core Image filters
- **High Quality Output**: 1024x1024 resolution results
- **Share Integration**: Built-in iOS share sheet
- **Dynamic Island**: Live Activities for processing status
- **Widget Support**: Home screen widget for quick access

### Smart Processing
- **Person Detection**: Optimized prompts for photos with people
- **Camera Angle Analysis**: Preserves original perspective and framing
- **Color Preservation**: Maintains important color elements
- **Composition Retention**: Keeps spatial relationships intact

## 🛠 Setup Instructions

### Prerequisites
- **Xcode 15.0+**
- **iOS 18.2+ deployment target**
- **OpenAI API account** with gpt-image-1 access

### API Configuration

1. **Get OpenAI API Access:**
   - Create account at [OpenAI Platform](https://platform.openai.com)
   - Complete identity verification for gpt-image-1 access
   - Generate API key from dashboard

2. **Configure Environment Variables:**
   
   **Method 1: Xcode Environment Variables (Recommended)**
   ```
   1. In Xcode: Product → Scheme → Edit Scheme
   2. Select "Run" → "Environment Variables"
   3. Add: OPENAI_API_KEY = your-api-key-here
   ```

   **Method 2: Terminal Export**
   ```bash
   export OPENAI_API_KEY="your-api-key-here"
   ```

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yuripetrosyan/CartoonMeV2.git
   cd CartoonMeV2
   ```

2. **Open in Xcode:**
   ```bash
   open CartoonMe.xcodeproj
   ```

3. **Set API Key** (see configuration above)

4. **Build and Run** on your iOS device or simulator

## 🎯 Usage

1. **Launch CartoonMe** on your iOS device
2. **Tap "Pick a photo"** to select an image
3. **Choose your style** from the 7 available options
4. **Tap "Cartoon It!"** to start transformation
5. **Watch the progress** with real-time effects
6. **View your result** and export/share

## 🏗 Technical Architecture

### Core Components
- **`ImageStylizer`**: Main processing engine with OpenAI integration
- **`ContentView`**: SwiftUI interface and state management
- **`ArtStyle`**: Enum defining 7 cartoon styles with optimized prompts
- **`ProgressStreamer`**: Real-time visual effects simulation
- **Vision Framework**: Person detection for prompt optimization

### API Integration Flow
```
1. Image Analysis (GPT-4o-mini)
   ↓ Privacy-safe scene description
2. Prompt Composition 
   ↓ Style + description + safety measures
3. Image Generation (gpt-image-1)
   ↓ High-quality cartoon transformation
4. Result Processing
   ↓ Display and sharing options
```

### Safety & Privacy
- **No facial recognition**: Generic "subject" references only
- **Content filtering**: Built-in moderation compliance  
- **Local processing**: Images analyzed securely via OpenAI API
- **No data storage**: No images stored on servers

## 🔄 Version History

### V2.0 (Current) - OpenAI Implementation
- Complete rewrite with OpenAI GPT-image-1
- Enhanced structure preservation
- 7 optimized cartoon styles
- Privacy-safe processing
- Dynamic Island integration

### V1.0 - Stability AI Implementation
- Initial release with Stability AI ControlNet
- Basic cartoon transformation
- Limited style options

## 🎨 Style Examples

Each style is optimized for different artistic preferences:

- **Studio Ghibli**: Soft watercolors, dreamy atmosphere, hand-painted feel
- **Simpsons**: Bold outlines, flat colors, classic TV animation
- **Disney 3D**: Modern CGI, family-friendly, bright lighting
- **Modern Anime**: Clean lines, cel shading, contemporary feel
- **Comic Book**: Bold illustrations, dramatic styling
- **Semi-Realistic**: Detailed but stylized, best of both worlds
- **Generic Cartoon**: Versatile style for any photo type

## 🚨 Troubleshooting

### Common Issues

**"Missing API Key" Error:**
- Ensure OPENAI_API_KEY is set in Xcode environment variables
- Check API key validity on OpenAI platform

**"Safety System" Block:**
- Try a different photo or simpler composition
- Ensure photo doesn't contain restricted content
- Use generic scenes for best results

**"Network Error":**
- Check internet connection
- Verify OpenAI account has sufficient credits
- Confirm API key permissions

**Build Errors:**
- Clean build folder (⌘+Shift+K)
- Restart Xcode
- Check iOS deployment target (18.2+)

## 💡 Tips for Best Results

- **Use clear, well-lit photos** for optimal analysis
- **Simple compositions** work better than complex scenes
- **Avoid copyrighted characters** in source photos
- **Generic clothing/settings** are safer for content moderation
- **Portrait orientation** often gives better results

## 📄 License

This project is available for educational and personal use. Please ensure compliance with OpenAI's terms of service when using their APIs.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly with different photo types
5. Submit a pull request

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review [OpenAI's API documentation](https://platform.openai.com/docs)
3. Open an issue in this repository

## 🌟 Future Plans

- **Additional art styles** (Pixar, Manga, etc.)
- **Batch processing** for multiple photos
- **Style intensity controls** for fine-tuning
- **Custom style creation** tools
- **Enhanced preview system**

---

**CartoonMe V2** - Transform your world into art! 🎨✨

*Powered by OpenAI GPT-image-1 | Built with SwiftUI | Made with ❤️*

  
