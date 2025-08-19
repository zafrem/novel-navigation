import React, { useState, useRef } from 'react'
import { Upload, Plus, Trash2, Save, Eye, EyeOff } from 'lucide-react'

const AuthorTools = ({ onStoryUpdate, currentStory, onModeChange }) => {
  const [isAuthorMode, setIsAuthorMode] = useState(false)
  const [editingStory, setEditingStory] = useState(currentStory)
  const [draggedScene, setDraggedScene] = useState(null)
  const fileInputRef = useRef(null)

  const handleAddScene = () => {
    const newScene = {
      id: Date.now(),
      title: `New Scene ${editingStory.scenes.length + 1}`,
      description: 'Enter scene description...',
      position: [51.505 + (Math.random() - 0.5) * 0.1, -0.09 + (Math.random() - 0.5) * 0.1],
      timestamp: editingStory.scenes.length
    }
    
    setEditingStory(prev => ({
      ...prev,
      scenes: [...prev.scenes, newScene]
    }))
  }

  const handleDeleteScene = (sceneId) => {
    setEditingStory(prev => ({
      ...prev,
      scenes: prev.scenes.filter(scene => scene.id !== sceneId)
        .map((scene, index) => ({ ...scene, timestamp: index }))
    }))
  }

  const handleSceneUpdate = (sceneId, field, value) => {
    setEditingStory(prev => ({
      ...prev,
      scenes: prev.scenes.map(scene =>
        scene.id === sceneId ? { ...scene, [field]: value } : scene
      )
    }))
  }

  const handlePositionUpdate = (sceneId, lat, lng) => {
    setEditingStory(prev => ({
      ...prev,
      scenes: prev.scenes.map(scene =>
        scene.id === sceneId ? { ...scene, position: [lat, lng] } : scene
      )
    }))
  }

  const handleSaveStory = () => {
    onStoryUpdate(editingStory)
    alert('Story saved successfully!')
  }

  const handleExportStory = () => {
    const dataStr = JSON.stringify(editingStory, null, 2)
    const dataBlob = new Blob([dataStr], { type: 'application/json' })
    const url = URL.createObjectURL(dataBlob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${editingStory.title.replace(/\s+/g, '_')}.json`
    link.click()
    URL.revokeObjectURL(url)
  }

  const handleImportStory = (event) => {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        try {
          const importedStory = JSON.parse(e.target.result)
          setEditingStory(importedStory)
          alert('Story imported successfully!')
        } catch (error) {
          alert('Error importing story: Invalid JSON format')
        }
      }
      reader.readAsText(file)
    }
  }

  if (!isAuthorMode) {
    return (
      <div className="author-toggle">
        <button 
          onClick={() => {
            setIsAuthorMode(true)
            onModeChange(true)
          }}
          className="btn btn-primary"
        >
          <Upload size={16} />
          Author Mode
        </button>
      </div>
    )
  }

  return (
    <div className="author-tools">
      <div className="author-header">
        <h3>Author Tools</h3>
        <button 
          onClick={() => {
            setIsAuthorMode(false)
            onModeChange(false)
          }}
          className="btn btn-secondary"
        >
          <Eye size={16} />
          Reader Mode
        </button>
      </div>

      <div className="story-meta">
        <label>
          Story Title:
          <input
            type="text"
            value={editingStory.title}
            onChange={(e) => setEditingStory(prev => ({ ...prev, title: e.target.value }))}
            className="input-field"
          />
        </label>
      </div>

      <div className="scenes-editor">
        <div className="scenes-header">
          <h4>Scenes ({editingStory.scenes.length})</h4>
          <button onClick={handleAddScene} className="btn btn-primary btn-sm">
            <Plus size={14} />
            Add Scene
          </button>
        </div>

        <div className="scenes-list">
          {editingStory.scenes.map((scene, index) => (
            <div key={scene.id} className="scene-editor">
              <div className="scene-editor-header">
                <span className="scene-number">#{index + 1}</span>
                <button 
                  onClick={() => handleDeleteScene(scene.id)}
                  className="btn btn-danger btn-sm"
                >
                  <Trash2 size={12} />
                </button>
              </div>
              
              <div className="scene-fields">
                <label>
                  Title:
                  <input
                    type="text"
                    value={scene.title}
                    onChange={(e) => handleSceneUpdate(scene.id, 'title', e.target.value)}
                    className="input-field"
                  />
                </label>
                
                <label>
                  Description:
                  <textarea
                    value={scene.description}
                    onChange={(e) => handleSceneUpdate(scene.id, 'description', e.target.value)}
                    className="textarea-field"
                    rows="3"
                  />
                </label>
                
                <div className="position-fields">
                  <label>
                    Latitude:
                    <input
                      type="number"
                      step="0.000001"
                      value={scene.position[0]}
                      onChange={(e) => handlePositionUpdate(scene.id, parseFloat(e.target.value), scene.position[1])}
                      className="input-field input-sm"
                    />
                  </label>
                  <label>
                    Longitude:
                    <input
                      type="number"
                      step="0.000001"
                      value={scene.position[1]}
                      onChange={(e) => handlePositionUpdate(scene.id, scene.position[0], parseFloat(e.target.value))}
                      className="input-field input-sm"
                    />
                  </label>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="author-actions">
        <button onClick={handleSaveStory} className="btn btn-primary">
          <Save size={16} />
          Save Story
        </button>
        
        <button onClick={handleExportStory} className="btn btn-secondary">
          <Upload size={16} />
          Export JSON
        </button>
        
        <label className="btn btn-secondary">
          <Upload size={16} />
          Import JSON
          <input
            ref={fileInputRef}
            type="file"
            accept=".json"
            onChange={handleImportStory}
            style={{ display: 'none' }}
          />
        </label>
      </div>

      <div className="author-help">
        <h4>Quick Tips:</h4>
        <ul>
          <li>Click on the map to set scene positions</li>
          <li>Drag scenes to reorder them</li>
          <li>Export your story to share with others</li>
          <li>Import existing stories to edit them</li>
        </ul>
      </div>
    </div>
  )
}

export default AuthorTools
