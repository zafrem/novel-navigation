# Quick Start Guide - Novel Navigation

## 🚀 One-Click Setup

### For macOS/Linux:
```bash
./start.sh
```

### For Windows:
```cmd
start.bat
```

## 🛑 Stopping the System

### For macOS/Linux:
```bash
./stop.sh
```

### For Windows:
```cmd
stop.bat
```

## 📋 What the Scripts Do

### Start Script:
1. **System Check**: Verifies your operating system and available resources
2. **Node.js Installation**: Automatically installs Node.js if not present
3. **Dependency Management**: Installs all required npm packages
4. **Server Launch**: Starts the development server at `http://localhost:3000`

### Stop Script:
1. **Process Detection**: Finds all Novel Navigation processes
2. **Graceful Shutdown**: Sends SIGTERM to allow clean exit
3. **Force Kill**: Terminates stubborn processes if needed
4. **Cleanup**: Removes temporary files and cache
5. **Verification**: Confirms all processes are stopped

## 🔧 Manual Setup (if needed)

If the automatic script doesn't work:

### 1. Install Node.js
- Visit [nodejs.org](https://nodejs.org/)
- Download and install the LTS version
- Restart your terminal

### 2. Install Dependencies
```bash
npm install
```

### 3. Start Development Server
```bash
npm run dev
```

## 🎮 Using the Application

### Reader Mode
- Navigate through story scenes using the timeline slider
- Click **Play** to auto-advance through the journey
- Toggle **Show Path** to view the protagonist's route
- Zoom and pan the map to explore

### Author Mode
- Click **Switch to Author Mode** in the sidebar
- **Add Scenes**: Click anywhere on the map
- **Edit Scenes**: Modify titles, descriptions, and coordinates
- **Drag Markers**: Reposition scenes by dragging
- **Export/Import**: Save and share your stories as JSON files

## 🛠️ Troubleshooting

### Node.js Issues
- Ensure Node.js version is 16.x or higher
- Try reinstalling from [nodejs.org](https://nodejs.org/)

### Permission Issues (macOS/Linux)
```bash
chmod +x start.sh
```

### Port Already in Use
- The app runs on port 3000 by default
- Close other applications using this port
- Or modify `vite.config.js` to use a different port

## 📁 Project Structure
```
novel-navigation/
├── src/
│   ├── App.jsx              # Main application
│   ├── components/
│   │   ├── AuthorTools.jsx  # Story editing tools
│   │   └── MapEditor.jsx    # Interactive map component
│   └── index.css            # Styling
├── start.sh                 # Unix start script
├── start.bat                # Windows start script
└── package.json             # Dependencies
```

## 🌐 Browser Compatibility
- Chrome (recommended)
- Firefox
- Safari
- Edge

## 📞 Support
If you encounter issues:
1. Check the console for error messages
2. Ensure all dependencies are installed
3. Verify Node.js version compatibility
4. Try clearing browser cache
