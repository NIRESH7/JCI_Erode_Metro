import React from "react";
import { useLocation, NavLink } from "react-router-dom";
import { Nav } from "react-bootstrap";
import logo from "assets/img/jci-erode-metro-clear.png";

function Sidebar({ color, image, routes }) {
  const location = useLocation();
  const activeRoute = (routeName) => {
    return location.pathname === routeName ? "active" : "";
  };

  return (
    <div className="sidebar" data-image={image} data-color={color}>
      <div
        className="sidebar-background"
        style={{
          backgroundImage: image ? "url(" + image + ")" : "none",
        }}
      />
      <div className="sidebar-wrapper">
        <div className="logo d-flex align-items-center justify-content-center">
          <a
            href="#home"
            className="simple-text logo-mini mx-2 my-2"
            onClick={(e) => e.preventDefault()}
          >
            <div className="logo-img d-flex align-items-center justify-content-center">
              <img
                src={logo}
                alt="JCI Erode Metro"
                style={{ width: "140px", height: "auto" }}
              />
            </div>
          </a>
        </div>
        <Nav>
          {routes
            .filter((data) => !data.sidebar_disable)
            .map((prop, key) => {
              if (prop.redirect) return null;
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
            })}
        </Nav>
      </div>
    </div>
  );
}

export default Sidebar;
