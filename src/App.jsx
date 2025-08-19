import React, { useState, useEffect } from 'react'
import { Play, Pause, RotateCcw, SkipForward } from 'lucide-react'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import AuthorTools from './components/AuthorTools'
import MapEditor from './components/MapEditor'

// Fix for default markers in react-leaflet
delete L.Icon.Default.prototype._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon-2x.png',
  iconUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
})

// Sample data for demonstration
const sampleStory = {
  title: "The Journey of Aria",
  scenes: [
    {
      id: 1,
      title: "The Village of Millbrook",
      description: "Aria begins her journey in the peaceful village of Millbrook, nestled in the valley.",
      position: [51.505, -0.09],
      timestamp: 0
    },
    {
      id: 2,
      title: "The Ancient Forest",
      description: "Following the old path, Aria enters the mysterious Ancient Forest where shadows dance between towering trees.",
      position: [51.515, -0.1],
      timestamp: 1
    },
    {
      id: 3,
      title: "The Mountain Pass",
      description: "After days of travel, Aria reaches the treacherous Mountain Pass, where the air grows thin and cold.",
      position: [51.525, -0.11],
      timestamp: 2
    },
    {
      id: 4,
      title: "The Crystal Lake",
      description: "Beyond the mountains lies the legendary Crystal Lake, its waters reflecting the sky like a mirror.",
      position: [51.535, -0.12],
      timestamp: 3
    }
  ]
}

function App() {
  const [currentScene, setCurrentScene] = useState(0)
  const [isPlaying, setIsPlaying] = useState(false)
  const [showPath, setShowPath] = useState(true)
  const [story, setStory] = useState(sampleStory)
  const [isAuthorMode, setIsAuthorMode] = useState(false)

  // Auto-advance scenes when playing
  useEffect(() => {
    if (isPlaying && currentScene < story.scenes.length - 1) {
      const timer = setTimeout(() => {
        setCurrentScene(prev => prev + 1)
      }, 3000) // Advance every 3 seconds
      return () => clearTimeout(timer)
    } else if (isPlaying && currentScene >= story.scenes.length - 1) {
      setIsPlaying(false)
    }
  }, [isPlaying, currentScene, story.scenes.length])

  const handlePlay = () => {
    setIsPlaying(!isPlaying)
  }

  const handleReset = () => {
    setCurrentScene(0)
    setIsPlaying(false)
  }

  const handleNext = () => {
    if (currentScene < story.scenes.length - 1) {
      setCurrentScene(prev => prev + 1)
    }
  }

  const handleStoryUpdate = (updatedStory) => {
    setStory(updatedStory)
    // Reset to first scene when story is updated
    setCurrentScene(0)
    setIsPlaying(false)
  }

  const handleScenePositionUpdate = (sceneId, lat, lng) => {
    setStory(prev => ({
      ...prev,
      scenes: prev.scenes.map(scene =>
        scene.id === sceneId ? { ...scene, position: [lat, lng] } : scene
      )
    }))
  }

  const handleMapClick = (lat, lng) => {
    if (isAuthorMode) {
      // Add new scene at clicked location
      const newScene = {
        id: Date.now(),
        title: `Scene ${story.scenes.length + 1}`,
        description: 'Click to edit description...',
        position: [lat, lng],
        timestamp: story.scenes.length
      }
      setStory(prev => ({
        ...prev,
        scenes: [...prev.scenes, newScene]
      }))
    }
  }

  const currentSceneData = story.scenes[currentScene]
  const pathPositions = story.scenes.slice(0, currentScene + 1).map(scene => scene.position)

  return (
    <div className="app">
      <header className="header">
        <h1>Novel Navigation - Interactive Map Visualization</h1>
      </header>
      
      <div className="main-content">
        <div className="map-container">
          <MapEditor
            story={story}
            currentScene={currentScene}
            showPath={showPath}
            isAuthorMode={isAuthorMode}
            onScenePositionUpdate={handleScenePositionUpdate}
            onMapClick={handleMapClick}
          />
        </div>
        
        <div className="sidebar">
          <div className="controls-panel">
            <div className="timeline-controls">
              <label htmlFor="timeline">Scene Timeline</label>
              <input
                id="timeline"
                type="range"
                min="0"
                max={story.scenes.length - 1}
                value={currentScene}
                onChange={(e) => setCurrentScene(parseInt(e.target.value))}
                className="timeline-slider"
                disabled={isAuthorMode}
              />
              
              <div className="control-buttons">
                <button onClick={handleReset} className="btn btn-secondary">
                  <RotateCcw size={16} />
                </button>
                <button onClick={handlePlay} className="btn btn-primary">
                  {isPlaying ? <Pause size={16} /> : <Play size={16} />}
                </button>
                <button onClick={handleNext} className="btn btn-secondary">
                  <SkipForward size={16} />
                </button>
              </div>
              
              <label>
                <input
                  type="checkbox"
                  checked={showPath}
                  onChange={(e) => setShowPath(e.target.checked)}
                />
                Show Path
              </label>
            </div>
          </div>
          
          {isAuthorMode ? (
            <AuthorTools
              currentStory={story}
              onStoryUpdate={handleStoryUpdate}
              onModeChange={setIsAuthorMode}
            />
          ) : (
            <div className="scene-info">
              <div className="scene-title">{currentSceneData?.title}</div>
              <div className="scene-description">{currentSceneData?.description}</div>
              <div style={{ marginTop: '1rem', fontSize: '0.9rem', color: '#7f8c8d' }}>
                Scene {currentScene + 1} of {story.scenes.length}
              </div>
              <button 
                onClick={() => setIsAuthorMode(true)}
                className="btn btn-secondary"
                style={{ marginTop: '1rem', width: '100%' }}
              >
                Switch to Author Mode
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default App
