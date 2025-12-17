// src/services/component/ProjectForm.jsx

import React, { useState } from 'react';
// CORRECTED PATH: Reaches src/services/api.js
import { createProject, updateProject } from '../api.js'; 

const ProjectForm = ({ onProjectCreated, onClose, initialProject }) => {
// ... (rest of the code is the same as before)
  const isEditing = !!initialProject;
  
  const [formData, setFormData] = useState(
    initialProject || {
      title: '',
      description: '',
      due_date: '',
      status: 'active' 
    }
  );
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };
  
  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError(null);
    
    try {
      if (isEditing) {
        await updateProject(formData.id, formData);
      } else {
        await createProject(formData); 
      }
      
      onClose();
      onProjectCreated();
      
    } catch (err) {
      setError(err.message || 'Operation failed.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const titleText = isEditing ? 'Edit Project' : 'Create New Project';
  const buttonText = isEditing ? 'Save Changes' : 'Create Project';

  return (
    <div style={{ border: '1px solid #ccc', padding: '15px', marginBottom: '20px', borderRadius: '5px' }}>
      <h3>{titleText}</h3>
      <form onSubmit={handleSubmit}>
        
        <label>Title:</label>
        <input 
          type="text" name="title" value={formData.title} onChange={handleChange} 
          required disabled={isSubmitting}
        />
        <br/><br/>
        
        <label>Description:</label>
        <textarea 
          name="description" value={formData.description} onChange={handleChange} 
          disabled={isSubmitting}
        ></textarea>
        <br/><br/>
        
        <label>Due Date:</label>
        <input 
          type="date" name="due_date" value={formData.due_date} onChange={handleChange} 
          required disabled={isSubmitting}
        />
        <br/><br/>
        
        <label>Status:</label>
        <select 
          name="status" value={formData.status} onChange={handleChange}
          disabled={isSubmitting}
        >
          <option value="active">Active</option>
          <option value="pending">Pending</option>
          <option value="completed">Completed</option>
        </select>
        <br/><br/>

        {error && <p style={{ color: 'red' }}>Error: {error}</p>}
        
        <button type="submit" disabled={isSubmitting}>
          {isSubmitting ? 'Saving...' : buttonText}
        </button>
        <button type="button" onClick={onClose} style={{ marginLeft: '10px' }} disabled={isSubmitting}>
          Cancel
        </button>
      </form>
    </div>
  );
};

export default ProjectForm;