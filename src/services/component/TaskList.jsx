import React, { useState, useEffect, useCallback } from 'react';
import { fetchTasks, deleteTask } from '../api.js'; 
import TaskForm from './TaskForm';

const TaskList = ({ projectId }) => {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [editingTask, setEditingTask] = useState(null);

  const loadTasks = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetchTasks(projectId);
      
      // FIX: Handle ActiveModelSerializers response (which is usually a direct array)
      const taskData = Array.isArray(response) ? response : response.tasks;
      
      setTasks(taskData || []); // If taskData is null/undefined, default to empty array
      
    } catch (err) {
      setError(err.message || 'Failed to load tasks.');
    } finally {
      setLoading(false);
    }
  }, [projectId]);

  useEffect(() => {
    loadTasks();
  }, [loadTasks]);

  const handleTaskSaved = () => {
    setShowForm(false);
    setEditingTask(null);
    loadTasks();
  };

  const handleEdit = (task) => {
    setEditingTask(task);
    setShowForm(false);
  };

  const handleDelete = async (taskId, title) => {
    if (window.confirm(`Are you sure you want to delete task: "${title}"?`)) {
      try {
        await deleteTask(projectId, taskId);
        loadTasks();
      } catch (err) {
        alert(`Failed to delete task: ${err.message}`);
      }
    }
  };

  if (loading) return <p style={{ marginLeft: '20px', fontStyle: 'italic' }}>Loading tasks...</p>;
  if (error) return <p style={{ color: 'red', marginLeft: '20px' }}>Task Error: {error}</p>;

  return (
    <div style={{ marginLeft: '20px', borderLeft: '3px solid #ccc', paddingLeft: '15px', marginTop: '10px' }}>
      <h5>Tasks ({tasks.length})</h5>

      {/* --- ADD TASK BUTTON --- */}
      <button 
        onClick={() => {
          setShowForm(true);
          setEditingTask(null);
        }}
        style={{ fontSize: '0.8em', padding: '5px 10px', marginBottom: '10px', backgroundColor: '#008080', color: 'white', border: 'none', cursor: 'pointer' }}
      >
        + Add Task
      </button>

      {/* --- CONDITIONAL FORM RENDERING (Create) --- */}
      {showForm && !editingTask && (
        <TaskForm
          projectId={projectId}
          onTaskSaved={handleTaskSaved}
          onClose={() => setShowForm(false)} 
        />
      )}

      {/* --- CONDITIONAL FORM RENDERING (Edit) --- */}
      {editingTask && (
        <TaskForm
          projectId={projectId}
          initialTask={editingTask}
          onTaskSaved={handleTaskSaved}
          onClose={() => setEditingTask(null)} 
        />
      )}

      {/* --- TASK LIST DISPLAY --- */}
      <ul style={{ listStyleType: 'disc', paddingLeft: '20px' }}>
        {tasks.length > 0 ? (
          tasks.map(task => (
            <li key={task.id} style={{ marginBottom: '5px' }}>
              <span style={{ fontWeight: 'bold' }}>{task.title}</span> (Status: {task.status})
              <button 
                onClick={() => handleEdit(task)}
                style={{ marginLeft: '10px', fontSize: '0.7em', padding: '2px 5px', backgroundColor: '#3498db', color: 'white', border: 'none' }}
              >
                Edit
              </button>
              <button 
                onClick={() => handleDelete(task.id, task.title)}
                style={{ marginLeft: '5px', fontSize: '0.7em', padding: '2px 5px', backgroundColor: '#e74c3c', color: 'white', border: 'none' }}
              >
                Delete
              </button>
            </li>
          ))
        ) : (
          <p style={{ fontStyle: 'italic', fontSize: '0.9em' }}>No tasks for this project yet.</p>
        )}
      </ul>
    </div>
  );
};

export default TaskList;