import React, { useEffect, useState, useCallback } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import srxc from "../assets/img/propic.png";
import { Tab, Tabs } from "react-bootstrap";
import { ToastContainer, toast } from "react-toastify";

const styles = {
  page: {
    padding: "4px 0 20px",
  },
  card: {
    background: "#fff",
    borderRadius: 8,
    border: "1px solid #E5E7EB",
    overflow: "hidden",
  },
  tableWrap: {
    overflowX: "auto",
  },
  table: {
    width: "100%",
    marginBottom: 0,
    borderCollapse: "collapse",
  },
  th: {
    background: "#F9FAFB",
    color: "#374151",
    fontSize: 12,
    fontWeight: 600,
    letterSpacing: "0.02em",
    textTransform: "uppercase",
    padding: "12px 14px",
    whiteSpace: "nowrap",
    borderBottom: "1px solid #E5E7EB",
    verticalAlign: "middle",
  },
  td: {
    padding: "12px 14px",
    verticalAlign: "middle",
    borderBottom: "1px solid #F3F4F6",
    fontSize: 13,
    color: "#111827",
  },
  avatar: {
    width: 40,
    height: 40,
    borderRadius: "50%",
    objectFit: "cover",
    border: "1px solid #E5E7EB",
    background: "#F3F4F6",
  },
  name: {
    fontWeight: 600,
    color: "#111827",
    textTransform: "capitalize",
    margin: 0,
  },
  muted: {
    color: "#9CA3AF",
    fontSize: 12,
  },
  actions: {
    display: "flex",
    gap: 6,
    flexWrap: "wrap",
    alignItems: "center",
  },
  btnBase: {
    display: "inline-flex",
    alignItems: "center",
    justifyContent: "center",
    border: "none",
    borderRadius: 6,
    padding: "6px 12px",
    fontSize: 12,
    fontWeight: 600,
    cursor: "pointer",
    whiteSpace: "nowrap",
  },
  btnView: {
    background: "#E8F4FD",
    color: "#1D6FB8",
  },
  btnUpdate: {
    background: "#FFF4E5",
    color: "#C77700",
  },
  btnGiveAccess: {
    background: "#E8F8EF",
    color: "#1B7A3D",
  },
  btnRevokeAccess: {
    background: "#FDECEC",
    color: "#C62828",
  },
  btnInactive: {
    background: "#FDECEC",
    color: "#C62828",
  },
  btnActive: {
    background: "#E8F8EF",
    color: "#1B7A3D",
  },
  accessWrap: {
    display: "flex",
    flexDirection: "column",
    gap: 6,
    alignItems: "flex-start",
    minWidth: 120,
  },
  pillFull: {
    display: "inline-flex",
    alignItems: "center",
    borderRadius: 999,
    padding: "3px 10px",
    fontSize: 11,
    fontWeight: 700,
    background: "#D1FAE5",
    color: "#065F46",
  },
  pillView: {
    display: "inline-flex",
    alignItems: "center",
    borderRadius: 999,
    padding: "3px 10px",
    fontSize: 11,
    fontWeight: 700,
    background: "#F3F4F6",
    color: "#4B5563",
  },
  empty: {
    textAlign: "center",
    padding: "36px 16px",
    color: "#6B7280",
    fontSize: 13,
  },
  count: {
    fontSize: 12,
    color: "#6B7280",
    marginBottom: 8,
  },
};

function Memberlist(props) {
  const [userList, setUserList] = useState([]);
  const [inactive, setInactive] = useState([]);
  const [loadingId, setLoadingId] = useState(null);
  const [accessLoadingId, setAccessLoadingId] = useState(null);

  const loadMembers = useCallback(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/allmembers")
      .then((res) => {
        setUserList(res.data.response.data.info || []);
      })
      .catch(() => setUserList([]));

    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/getInActiveMembers")
      .then((res) => {
        setInactive(res.data.response.data.info || []);
      })
      .catch(() => setInactive([]));
  }, []);

  useEffect(() => {
    loadMembers();
  }, [loadMembers]);

  function Update(id) {
    props.history.push("./SingleMember?id=" + id);
  }

  function Updated(id) {
    props.history.push("./UpdateMember?id=" + id);
  }

  function toggleStatus(member, nextStatus) {
    setLoadingId(member.id);
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/changeStatus", {
        id: member.id,
        status: nextStatus,
      })
      .then(() => {
        toast.success(
          nextStatus === "inactive"
            ? `${member.user_name} is now inactive`
            : `${member.user_name} is now active`
        );
        loadMembers();
      })
      .catch((err) => {
        if (err?.response?.data?.error?.message === "Authentication Failed") {
          localStorage.clear();
          window.location.reload();
          return;
        }
        toast.error("Failed to update member status");
      })
      .finally(() => setLoadingId(null));
  }

  function toggleAppAccess(member, nextAccess) {
    setAccessLoadingId(member.id);
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/changeAppAccess", {
        id: member.id,
        app_access: nextAccess,
      })
      .then(() => {
        toast.success(
          nextAccess === "full"
            ? `${member.user_name} can appear in Members and give/receive referrals`
            : `${member.user_name} is now view only`
        );
        loadMembers();
      })
      .catch((err) => {
        if (err?.response?.data?.error?.message === "Authentication Failed") {
          localStorage.clear();
          window.location.reload();
          return;
        }
        toast.error("Failed to update member access");
      })
      .finally(() => setAccessLoadingId(null));
  }

  const renderStatusButton = (member, isActiveTab) => {
    const busy = loadingId === member.id;
    return (
      <button
        type="button"
        style={{
          ...styles.btnBase,
          ...(isActiveTab ? styles.btnInactive : styles.btnActive),
          opacity: busy ? 0.6 : 1,
        }}
        disabled={busy}
        onClick={() => toggleStatus(member, isActiveTab ? "inactive" : "active")}
      >
        {busy ? "..." : isActiveTab ? "Set Inactive" : "Set Active"}
      </button>
    );
  };

  const renderAccessCell = (member) => {
    const busy = accessLoadingId === member.id;
    const hasFull = member.app_access === "full";
    return (
      <div style={styles.accessWrap}>
        <span style={hasFull ? styles.pillFull : styles.pillView}>
          {hasFull ? "Full access" : "View only"}
        </span>
        <button
          type="button"
          style={{
            ...styles.btnBase,
            ...(hasFull ? styles.btnRevokeAccess : styles.btnGiveAccess),
            opacity: busy ? 0.6 : 1,
          }}
          disabled={busy}
          onClick={() => toggleAppAccess(member, hasFull ? "view" : "full")}
        >
          {busy ? "..." : hasFull ? "Remove Access" : "Give Access"}
        </button>
      </div>
    );
  };

  const renderRows = (list, isActiveTab) =>
    Array.isArray(list) && list.length !== 0 ? (
      list.map((x) => (
        <tr key={x.id}>
          <td style={styles.td}>
            <img
              src={x.profile_pic}
              onError={(e) => (e.currentTarget.src = srxc)}
              style={styles.avatar}
              alt="profile"
            />
          </td>
          <td style={styles.td}>
            <span style={{ color: "#6B7280" }}>#{x.id}</span>
          </td>
          <td style={styles.td}>
            <p style={styles.name}>{x.user_name || "—"}</p>
          </td>
          <td style={styles.td}>{x.email || "—"}</td>
          <td style={styles.td}>{x.contact || "—"}</td>
          <td style={{ ...styles.td, textTransform: "capitalize" }}>
            {x.location || <span style={styles.muted}>—</span>}
          </td>
          <td style={{ ...styles.td, textTransform: "capitalize" }}>
            {x.role || <span style={styles.muted}>—</span>}
          </td>
          <td style={styles.td}>
            <div style={styles.actions}>
              <button
                type="button"
                style={{ ...styles.btnBase, ...styles.btnView }}
                onClick={() => Update(x.id)}
              >
                View
              </button>
              <button
                type="button"
                style={{ ...styles.btnBase, ...styles.btnUpdate }}
                onClick={() => Updated(x.id)}
              >
                Update
              </button>
            </div>
          </td>
          <td style={styles.td}>{renderAccessCell(x)}</td>
          <td style={styles.td}>{renderStatusButton(x, isActiveTab)}</td>
        </tr>
      ))
    ) : (
      <tr>
        <td colSpan="10" style={styles.empty}>
          No members found
        </td>
      </tr>
    );

  const renderTable = (list, isActiveTab) => (
    <div style={styles.card}>
      <div style={{ padding: "10px 14px 0" }}>
        <div style={styles.count}>
          {Array.isArray(list) ? list.length : 0} member
          {(Array.isArray(list) ? list.length : 0) === 1 ? "" : "s"}
        </div>
      </div>
      <div style={styles.tableWrap}>
        <table style={styles.table} className="table mb-0">
          <thead>
            <tr>
              <th style={styles.th}>Photo</th>
              <th style={styles.th}>ID</th>
              <th style={styles.th}>Name</th>
              <th style={styles.th}>Email</th>
              <th style={styles.th}>Contact</th>
              <th style={styles.th}>Location</th>
              <th style={styles.th}>Role</th>
              <th style={styles.th}>Action</th>
              <th style={styles.th}>Access</th>
              <th style={styles.th}>Status</th>
            </tr>
          </thead>
          <tbody>{renderRows(list, isActiveTab)}</tbody>
        </table>
      </div>
    </div>
  );

  return (
    <div style={styles.page} className="container-fluid">
      <ToastContainer />
      <style>{`
        .member-list-tabs .nav-tabs {
          border-bottom: 1px solid #E5E7EB;
          margin-bottom: 14px;
        }
        .member-list-tabs .nav-tabs .nav-link {
          border: none;
          color: #6B7280;
          font-weight: 500;
          font-size: 14px;
          padding: 8px 14px;
          background: transparent;
          border-radius: 0;
        }
        .member-list-tabs .nav-tabs .nav-link.active {
          color: #111827;
          background: transparent;
          border-bottom: 2px solid #111827;
        }
        .member-list-tabs .nav-tabs .nav-link:hover {
          color: #111827;
          border-color: transparent;
        }
      `}</style>
      <div className="member-list-tabs">
        <Tabs defaultActiveKey="home" id="member-list-tabs">
          <Tab eventKey="home" title="Active Members">
            {renderTable(userList, true)}
          </Tab>
          <Tab eventKey="profile" title="Inactive Members">
            {renderTable(inactive, false)}
          </Tab>
        </Tabs>
      </div>
    </div>
  );
}

export default Memberlist;
