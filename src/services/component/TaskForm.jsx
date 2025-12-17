import React, { useState } from 'react';
import { createTask, updateTask } from '../api.js'; 

const STATUS = {
  pending: 0,
  in_progress: 1,
  completed: 2
};

const TaskForm = ({ projectId, onTaskSaved, onClose, initialTask }) => {
  const isEditing = !!initialTask;

  const [formData, setFormData] = useState(
    initialTask
      ? { ...initialTask }
      : {
          title: '',
          description: '',
          due_date: '',
          status: 'pending' // frontend uses string key
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
      // Map the status string to the integer before sending to backend
      const payload = {
        ...formData,
        status: STATUS[formData.status] // converts "pending" -> 0, etc.
      };

      if (isEditing) {
        await updateTask(projectId, formData.id, payload);
      } else {
        await createTask(projectId, payload);
      }

      onTaskSaved();
      onClose();
    } catch (err) {
      setError(err.message || 'Task operation failed.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const titleText = isEditing ? 'Edit Task' : 'Add New Task';
  const buttonText = isEditing ? 'Save Changes' : 'Create Task';

  return (
    <div
      style={{
        border: '1px dashed #008080',
        padding: '15px',
        marginTop: '10px',
        borderRadius: '5px',
        backgroundColor: '#e0ffff'
      }}
    >
      <h4>{titleText}</h4>
      <form onSubmit={handleSubmit}>
        <label>Title:</label>
        <input
          type="text"
          name="title"
          value={formData.title}
          onChange={handleChange}
          required
          disabled={isSubmitting}
        />
        <br /><br />

        <label>Description:</label>
        <textarea
          name="description"
          value={formData.description}
          onChange={handleChange}
          required
          disabled={isSubmitting}
        ></textarea>
        <br /><br />

        <label>Due Date:</label>
        <input
          type="date"
          name="due_date"
          value={formData.due_date}
          onChange={handleChange}
          required
          disabled={isSubmitting}
        />
        <br /><br />

        <label>Status:</label>
        <select
          name="status"
          value={formData.status}
          onChange={handleChange}
          required
          disabled={isSubmitting}
        >
          <option value="pending">Pending</option>
          <option value="in_progress">In Progress</option>
          <option value="completed">Completed</option>
        </select>
        <br /><br />

        {error && <p style={{ color: 'red' }}>Error: {error}</p>}

        <button type="submit" disabled={isSubmitting}>
          {isSubmitting ? 'Saving...' : buttonText}
        </button>
        <button
          type="button"
          onClick={onClose}
          style={{ marginLeft: '10px' }}
          disabled={isSubmitting}
        >
          Cancel
        </button>
      </form>
    </div>
  );
};

export default TaskForm;
