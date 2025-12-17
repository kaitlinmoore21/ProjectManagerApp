// src/services/api.js

const API_BASE_URL = 'http://localhost:3000/api/v1'; 

// --- Helper Functions ---

const getAuthToken = () => {
  return localStorage.getItem('authToken');
};

const apiSend = async (endpoint, method, data = null) => {
  const token = getAuthToken();
  if (!token) {
    throw new Error('Authentication required. Please log in.');
  }

  const options = {
    method: method,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}` 
    },
  };

  if (data) {
    options.body = JSON.stringify(data);
  }

  const response = await fetch(`${API_BASE_URL}${endpoint}`, options);

  if (response.status === 204) {
    return null; 
  }

  if (!response.ok) {
    const errorBody = await response.json().catch(() => ({ error: 'Unknown API error' }));
    
    let errorMessage = errorBody.error || `HTTP error! Status: ${response.status}`;
    if (errorBody.errors) {
      errorMessage = errorBody.errors.join('; '); 
    }
    
    throw new Error(errorMessage);
  }

  return response.json();
};

const apiFetch = async (endpoint, params = {}) => {
  const token = getAuthToken();
  if (!token) {
    throw new Error('Authentication required. Please log in.');
  }

  const queryString = new URLSearchParams(params).toString();
  const url = `${API_BASE_URL}${endpoint}?${queryString}`;

  const response = await fetch(url, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}` 
    }
  });

  if (!response.ok) {
    const errorBody = await response.json().catch(() => ({ error: 'Unknown API error' }));
    throw new Error(errorBody.error || `HTTP error! Status: ${response.status}`);
  }

  return response.json();
};

// --- Authentication Functions ---

export const loginUser = async (email, password) => {
  const response = await fetch(`${API_BASE_URL}/login`, { 
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }) 
  });

  if (!response.ok) {
    const errorBody = await response.json().catch(() => ({ error: 'Login failed' }));
    throw new Error(errorBody.error || 'Login failed.');
  }

  const data = await response.json();
  if (data.token) {
    localStorage.setItem('authToken', data.token);
  } else {
     throw new Error('Login succeeded, but no token was returned by the backend.');
  }
  return data;
};

export const logoutUser = () => {
  localStorage.removeItem('authToken');
};

// --- Project CRUD Functions ---

export const fetchProjects = (page = 1, per_page = 10) => {
  return apiFetch('/projects', { page, per_page });
};

export const createProject = async (projectData) => {
  return apiSend('/projects', 'POST', { project: projectData });
};

export const fetchProject = (projectId) => {
  return apiFetch(`/projects/${projectId}`);
};

export const updateProject = (projectId, projectData) => {
  return apiSend(`/projects/${projectId}`, 'PATCH', { project: projectData });
};

export const deleteProject = (projectId) => {
  return apiSend(`/projects/${projectId}`, 'DELETE');
};

//-- Task CRUD Functions (Nested under Project) ---

export const fetchTasks = (projectId) => {
  // GET /api/v1/projects/:project_id/tasks
  return apiFetch(`/projects/${projectId}/tasks`);
};

export const createTask = (projectId, taskData) => {
  // POST /api/v1/projects/:project_id/tasks
  return apiSend(`/projects/${projectId}/tasks`, 'POST', { task: taskData });
};

export const updateTask = (projectId, taskId, taskData) => {
  // PATCH /api/v1/projects/:project_id/tasks/:id
  return apiSend(`/projects/${projectId}/tasks/${taskId}`, 'PATCH', { task: taskData });
};

export const deleteTask = (projectId, taskId) => {
  // DELETE /api/v1/projects/:project_id/tasks/:id
  return apiSend(`/projects/${projectId}/tasks/${taskId}`, 'DELETE');
};