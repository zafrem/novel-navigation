# Novel Navigation - Interactive Map Visualization System

An interactive web-based platform that allows readers to follow a protagonist's journey on a map while reading a novel. Maps can display geographical features, place names, and dynamic changes such as earthquakes or tsunamis that alter the map in real time.

## Features

- **Interactive Map Visualization**: Display real-world or fantasy maps with protagonist movement
- **Timeline Controls**: Play, pause, and navigate through story scenes
- **Dynamic Path Tracking**: Visualize the protagonist's route with animated paths
- **Scene Management**: Switch between story events and observe map transformations
- **Responsive Design**: Modern, intuitive interface for both authors and readers

## Tech Stack

- **Frontend**: React + Vite
- **Mapping**: Leaflet + React-Leaflet
- **Styling**: CSS3 with modern design patterns
- **Icons**: Lucide React

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- npm or yarn

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd novel-navigation
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

4. Open your browser and navigate to `http://localhost:3000`

## Usage

### For Readers
- Use the timeline slider to navigate through story scenes
- Click play to auto-advance through the protagonist's journey
- Toggle the "Show Path" option to view/hide the traveled route
- Zoom and pan the map to explore different areas
- Click on markers to see scene details

### For Authors (Coming Soon)
- Upload custom maps (real-world or fantasy)
- Define protagonist routes and waypoints
- Create scene transitions and events
- Export projects as shareable web pages

## Project Structure

```
src/
├── App.jsx          # Main application component
├── main.jsx         # React entry point
├── index.css        # Global styles
└── components/      # Reusable components (future)
```

## Development Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

## Future Enhancements

- Author tools for map upload and route definition
- Support for multiple map layers and overlays
- Event system for dynamic map changes
- Backend API for data persistence
- Multiplayer reading experiences
- AR/VR integration

## License

MIT License - see LICENSE file for details
