import React, { useState } from "react";
import Axios from "axios";
import img from "../assets/img/jci.png";
import "./login.css";

const initialState = {
  login: "",
  password: "",
};

const LoginForm = () => {
  const [err, setErr] = useState("");
  const [storeData, setStoreData] = useState(initialState);

  const handleformchange = (e) => {
    setStoreData({
      ...storeData,
      [e.target.name]: e.target.value,
    });
  };

  const handleformSubmit = (e) => {
    e.preventDefault();
    Axios.post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/login", {
      login: storeData.login,
      password: storeData.password,
    }).then((res) => {
      if (
        res.data.data.token !== "" &&
        res.data.data.token !== null &&
        res.data.data.token !== undefined
      ) {
        window.location.href = "/dashboard";
        localStorage.setItem("tok", res.data.data.token);
      }

      if (res.data.data && typeof res.data.data) {
        setErr(res.data.data);
      } else {
        setErr("Login Failed");
      }
    });
  };

  return (
    <div className="login-page">
      <div className="login-brand">
        <img
          src={img}
          alt="JCI Erode Greencity"
          className="login-logo"
        />
      </div>

      <div className="login-panel">
        <div className="login-card card">
          <div className="card-body form-align">
            <h2 className="card-title" id="signin">
              Sign in
            </h2>
            <form onSubmit={handleformSubmit}>
              <div className="form-group">
                <label htmlFor="login-email">Email / UserName / Phone</label>
                <input
                  id="login-email"
                  type="text"
                  name="login"
                  required
                  placeholder="Enter Email/UserName/Phone"
                  className="form-control"
                  value={storeData.login}
                  onChange={handleformchange}
                />
              </div>
              <div className="form-group">
                <label htmlFor="login-password">Password</label>
                <input
                  id="login-password"
                  type="password"
                  name="password"
                  required
                  placeholder="Password"
                  className="form-control"
                  value={storeData.password}
                  onChange={handleformchange}
                />
              </div>
              {err ? <p className="login-error">{err}</p> : null}
              <div className="button">
                <button type="submit" className="btn btn-primary login-btn">
                  Log in
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginForm;
