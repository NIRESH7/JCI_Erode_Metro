import React, { useState } from "react";
import Axios from "axios";
import logo from "../assets/img/jci-erode-metro-clear.png";
import "./login.css";

const initialState = {
  login: "",
  password: "",
};

const LoginForm = () => {
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(false);
  const [storeData, setStoreData] = useState(initialState);

  const handleformchange = (e) => {
    setStoreData({
      ...storeData,
      [e.target.name]: e.target.value,
    });
    if (err) setErr("");
  };

  const handleformSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setErr("");
    Axios.post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/login", {
      login: storeData.login,
      password: storeData.password,
    })
      .then((res) => {
        if (
          res.data.data.token !== "" &&
          res.data.data.token !== null &&
          res.data.data.token !== undefined
        ) {
          localStorage.setItem("tok", res.data.data.token);
          window.location.href = "/dashboard";
          return;
        }

        if (res.data.data && typeof res.data.data) {
          setErr(res.data.data);
        } else {
          setErr("Login failed. Check your credentials.");
        }
      })
      .catch(() => {
        setErr("Unable to reach the server. Is the backend running?");
      })
      .finally(() => {
        setLoading(false);
      });
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <img src={logo} alt="JCI Erode Metro" className="login-logo" />

        <div className="login-heading">
          <h1>Sign in</h1>
          <p>Welcome to JCI Erode Metro</p>
        </div>

        <form onSubmit={handleformSubmit}>
          <label className="login-field" htmlFor="login-email">
            <span>Email or username</span>
            <input
              id="login-email"
              type="text"
              name="login"
              required
              autoComplete="username"
              placeholder="admin@jci.local"
              value={storeData.login}
              onChange={handleformchange}
            />
          </label>

          <label className="login-field" htmlFor="login-password">
            <span>Password</span>
            <input
              id="login-password"
              type="password"
              name="password"
              required
              autoComplete="current-password"
              placeholder="Enter password"
              value={storeData.password}
              onChange={handleformchange}
            />
          </label>

          {err ? (
            <p className="login-error" role="alert">
              {err}
            </p>
          ) : null}

          <button type="submit" className="login-submit" disabled={loading}>
            {loading ? "Signing in…" : "Log in"}
          </button>
        </form>
      </div>
    </div>
  );
};

export default LoginForm;
