import React from 'react';
import styles from './App.css';
import NavBar from './common/Navbar';
import NavLink from './common/NavLink';





const App = () => (
  <div className={styles.app}>
    <NavBar />
    <h2>Hello, KegCop.</h2>
  </div>
);

export default App;
