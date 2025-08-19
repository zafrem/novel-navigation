import React, { useCallback } from 'react'
import { MapContainer, TileLayer, Marker, Popup, Polyline, useMapEvents } from 'react-leaflet'

const MapClickHandler = ({ onMapClick, isAuthorMode }) => {
  useMapEvents({
    click: (e) => {
      if (isAuthorMode && onMapClick) {
        onMapClick(e.latlng.lat, e.latlng.lng)
      }
    }
  })
  return null
}

const DraggableMarker = ({ scene, onPositionChange, isAuthorMode }) => {
  const eventHandlers = useCallback({
    dragend: (e) => {
      const marker = e.target
      const newPos = marker.getLatLng()
      onPositionChange(scene.id, newPos.lat, newPos.lng)
    }
  }, [scene.id, onPositionChange])

  return (
    <Marker
      position={scene.position}
      draggable={isAuthorMode}
      eventHandlers={isAuthorMode ? eventHandlers : {}}
    >
      <Popup>
        <div>
          <h3>{scene.title}</h3>
          <p>{scene.description}</p>
          {isAuthorMode && (
            <div style={{ marginTop: '8px', fontSize: '0.8em', color: '#666' }}>
              Lat: {scene.position[0].toFixed(6)}<br/>
              Lng: {scene.position[1].toFixed(6)}<br/>
              <em>Drag to reposition</em>
            </div>
          )}
        </div>
      </Popup>
    </Marker>
  )
}

const MapEditor = ({ 
  story, 
  currentScene, 
  showPath, 
  isAuthorMode, 
  onScenePositionUpdate,
  onMapClick 
}) => {
  const currentSceneData = story.scenes[currentScene]
  const pathPositions = story.scenes.slice(0, currentScene + 1).map(scene => scene.position)

  return (
    <MapContainer
      center={currentSceneData ? currentSceneData.position : [51.505, -0.09]}
      zoom={13}
      style={{ height: '100%', width: '100%' }}
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      
      <MapClickHandler onMapClick={onMapClick} isAuthorMode={isAuthorMode} />
      
      {/* Render all scenes in author mode, or just current scene in reader mode */}
      {isAuthorMode ? (
        // Author mode: show all scenes
        story.scenes.map((scene, index) => (
          <DraggableMarker
            key={scene.id}
            scene={scene}
            onPositionChange={onScenePositionUpdate}
            isAuthorMode={isAuthorMode}
          />
        ))
      ) : (
        // Reader mode: show only current scene
        currentSceneData && (
          <DraggableMarker
            key={currentSceneData.id}
            scene={currentSceneData}
            onPositionChange={onScenePositionUpdate}
            isAuthorMode={isAuthorMode}
          />
        )
      )}
      
      {/* Path visualization */}
      {showPath && pathPositions.length > 1 && (
        <Polyline
          positions={isAuthorMode ? story.scenes.map(s => s.position) : pathPositions}
          color={isAuthorMode ? "#e74c3c" : "#3498db"}
          weight={3}
          opacity={0.8}
          dashArray={isAuthorMode ? "10, 10" : undefined}
        />
      )}
    </MapContainer>
  )
}

export default MapEditor
