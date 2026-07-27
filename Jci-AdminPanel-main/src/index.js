import React from "react";
import ReactDOM from "react-dom";
import App from './App';

import { BrowserRouter, Route, Switch, Redirect } from "react-router-dom";
import axios from "axios"

import "bootstrap/dist/css/bootstrap.min.css";
import "./assets/css/animate.min.css";
import 'react-toastify/dist/ReactToastify.css';
import "./assets/scss/light-bootstrap-dashboard-react.scss?v=2.0.0";
import "./assets/css/demo.css";
import "@fortawesome/fontawesome-free/css/all.min.css";





ReactDOM.render(
  <BrowserRouter>
    
    <App/>
  </BrowserRouter>,
  document.getElementById("root")
);
