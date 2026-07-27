
import React, { Component } from "react";
import { useLocation, NavLink } from "react-router-dom";

import { Nav } from "react-bootstrap";

import logo from "assets/img/reactlogo.png";

function Sidebar({ color, image, routes }) {
  const location = useLocation();
  const activeRoute = (routeName) => {
    ("rote-name", routeName, location.pathname===routeName ? "active" : "");
    return location.pathname===routeName ?"active" : "";
  };
  return (
    <div className="sidebar" data-image={image} data-color={color}>
      <div
        className="sidebar-background"
        style={{
          backgroundImage: "url(" + image + ")",
        }}
      />
      <div className="sidebar-wrapper">
        <div className="logo d-flex align-items-center justify-content-center">
          <a
            href=""
            className="simple-text logo-mini mx-2 my-2"
          >
            <div className="logo-img d-flex align-items-center " >
             <img
                src={require("assets/img/jci.png").default}
                alt="jci"
              style={{width:"100px"}}
              />
            </div>
          </a>
          <a className="simple-text" href="#">
         
          </a>
        </div>
        <Nav>
          {routes.filter(data=>!data.sidebar_disable).map((prop, key) => {
            if (!prop.redirect)
              return (
                <li
                  className={
                    prop.upgrade
                      ? "active active-pro"
                      : activeRoute(prop.layout + prop.path)
                  }
                  key={key}
                >
                  <NavLink
                    to={prop.layout + prop.path}
                    className="nav-link"
                    activeClassName="active"
                  >
                    <i
                      className={prop.icon}
                      style={{ color: prop.iconColor || "#FFFFFF" }}
                    />
                    <p>{prop.name}</p>
                  </NavLink>
                </li>
              );
            return null;
          })}
        </Nav>
      </div>
    </div>
  );
}

export default Sidebar;
