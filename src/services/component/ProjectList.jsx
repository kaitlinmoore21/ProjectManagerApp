

import React, { useState, useEffect, useCallback } from 'react';
import { fetchProjects, logoutUser, deleteProject } from '../api.js'; 
import ProjectForm from './ProjectForm'; 
import TaskList from './TaskList'; 

const ProjectList = ({ onLogout }) => {
  const [projects, setProjects] = useState([]);
  const [meta, setMeta] = useState({ current_page: 1, total_pages: 1, total_count: 0 });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showCreateForm, setShowCreateForm] = useState(false); 
  const [editingProject, setEditingProject] = useState(null); 
  const [expandedProjectId, setExpandedProjectId] = useState(null); 

  const loadProjects = useCallback(async (pageNumber) => {
 
    setLoading(true);
    setError(null);
    try {
      const response = await fetchProjects(pageNumber, 5); 
      
      setProjects(response.projects);
      setMeta(response.meta);
    } catch (err) {
      setError(err.message || 'Failed to load projects.');
      if (err.message && err.message.includes('Authentication required')) {
        onLogout();
      }
    } finally {
      setLoading(false);
    }
  }, [onLogout]);

  useEffect(() => {
    loadProjects(meta.current_page);
  }, [loadProjects, meta.current_page]); 

  // --- Handlers ---
  // ... (handlePageChange, handleLogout, handleProjectCreatedOrUpdated, handleEdit, handleDelete are unchanged)
  const handlePageChange = (newPage) => {
    setMeta(prevMeta => ({ ...prevMeta, current_page: newPage }));
  };

  const handleLogout = () => {
    logoutUser();
    onLogout();
  };
  
  const handleProjectCreatedOrUpdated = () => {
    loadProjects(1);
    setShowCreateForm(false);
    setEditingProject(null);
  }

  const handleEdit = (project) => {
    setEditingProject(project);
    setShowCreateForm(false);
  }

  const handleDelete = async (projectId, title) => {
    if (window.confirm(`Are you sure you want to delete project: "${title}"?`)) {
      try {
        await deleteProject(projectId);
        handleProjectCreatedOrUpdated();
      } catch (err) {
        alert(`Failed to delete project: ${err.message}`);
      }
    }
  }

  const toggleTasks = (projectId) => {
    setExpandedProjectId(currentId => (currentId === projectId ? null : projectId));
  };


  if (loading) return <h2>Loading projects...</h2>;
  if (error) return <h2 style={{ color: 'red' }}>Error: {error}</h2>;

  return (
    <div style={{ padding: '20px' }}>
      <h1>My Projects</h1>
      <button onClick={handleLogout} style={{ float: 'right' }}>Logout</button>
      
      {/* --- CREATE BUTTON --- */}
      <button 
        onClick={() => {
          setShowCreateForm(true);
          setEditingProject(null);
        }}
        style={{ margin: '10px 0', padding: '10px', backgroundColor: '#4CAF50', color: 'white', border: 'none', cursor: 'pointer' }}
      >
        + Add New Project
      </button>

      {/* --- CONDITIONAL FORM RENDERING (Create/Edit) --- */}
      {showCreateForm && !editingProject && (
        <ProjectForm onProjectCreated={handleProjectCreatedOrUpdated} onClose={() => setShowCreateForm(false)} />
      )}
      {editingProject && (
        <ProjectForm initialProject={editingProject} onProjectCreated={handleProjectCreatedOrUpdated} onClose={() => setEditingProject(null)} />
      )}
      
      {/* --- PROJECT LIST --- */}
      <ul>
        {projects.length > 0 ? (
          projects.map(project => (
            <li key={project.id} style={{ borderBottom: '1px dotted #ccc', padding: '10px 0' }}>
              <div>
                <strong>{project.title}</strong> (Due: {project.due_date}) - Status: {project.status}
              </div>
              <div style={{ marginTop: '5px' }}>
                <button 
                  onClick={() => toggleTasks(project.id)} 
                  style={{ marginRight: '10px', backgroundColor: '#f39c12', color: 'white', border: 'none' }}
                >
                  {expandedProjectId === project.id ? 'Hide Tasks' : 'View Tasks'}
                </button>
                <button 
                  onClick={() => handleEdit(project)}
                  style={{ marginRight: '10px', backgroundColor: '#3498db', color: 'white', border: 'none' }}
                >
                  Edit
                </button>
                <button 
                  onClick={() => handleDelete(project.id, project.title)}
                  style={{ backgroundColor: '#e74c3c', color: 'white', border: 'none' }}
                >
                  Delete
                </button>
              </div>
              
              {/* <<< NEW: Conditional Task List Rendering */}
              {expandedProjectId === project.id && (
                <TaskList projectId={project.id} />
              )}
            </li>
          ))
        ) : (
          <p>No projects found on this page.</p>
        )}
      </ul>

      {/* --- Pagination Controls --- */}
      {/* ... (Unchanged Pagination Code) ... */}
      <div style={{ marginTop: '20px', borderTop: '1px solid #eee', paddingTop: '10px' }}>
        <p>Page {meta.current_page} of {meta.total_pages} ({meta.total_count} total)</p>
        
        <button 
          onClick={() => handlePageChange(meta.current_page - 1)} 
          disabled={meta.current_page <= 1}
        >
          &larr; Previous
        </button>
        
        <button 
          onClick={() => handlePageChange(meta.current_page + 1)} 
          disabled={meta.current_page >= meta.total_pages}
          style={{ marginLeft: '10px' }}
        >
          Next &rarr;
        </button>
      </div>
    </div>
  );
};

export default ProjectList;