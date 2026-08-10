import React, { useEffect, useMemo, useState } from "react";
import axios from "axios";
import { Link } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import srxc from "../assets/img/img.svg";
import ListToolbar, { matchesSearch } from "../components/ListToolbar";
import ListPagination, { paginate } from "../components/ListPagination";

const EventList = (props) => {
  const [eventlist, setEventlist] = useState([]);
  const [render, setRender] = useState(true);
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/allevents")
      .then((res) => {
        setEventlist(res.data.response.data.info || []);
      })
      .catch(() => setEventlist([]));
  }, [render]);

  const filtered = useMemo(
    () =>
      (eventlist || []).filter((x) =>
        matchesSearch(x, search, [
          "event_name",
          "event_date",
          "event_time",
          "event_location",
          "id",
        ])
      ),
    [eventlist, search]
  );

  const { page: safePage, totalPages, total, slice } = useMemo(
    () => paginate(filtered, page),
    [filtered, page]
  );

  useEffect(() => {
    if (page !== safePage) setPage(safePage);
  }, [page, safePage]);

  const onSearchChange = (value) => {
    setSearch(value);
    setPage(1);
  };

  function Update(id) {
    props.history.push("./SingleEvent?id=" + id);
  }
  function Updatee(id) {
    props.history.push("./Event_image_single?id=" + id);
  }
  function handledelete(id) {
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/deleteEvent", {
        id: id,
      })
      .then((res) => {
        if (res.data.response.data.info == "Event Deleted") setRender(!render);
      });
  }

  return (
    <div className="container-fluid p-3">
      <ListToolbar
        title="Event List"
        search={search}
        onSearchChange={onSearchChange}
        placeholder="Search events by name, date, location…"
        count={total}
        countLabel="events"
      />
      <div className="list-table-card">
        <div className="table-responsive">
          <table className="table table-sm mb-0">
            <thead>
              <tr>
                <th>S.No</th>
                <th>Event Name</th>
                <th>Image</th>
                <th>Date</th>
                <th>Time</th>
                <th>Location</th>
                <th style={{ minWidth: 220 }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {slice.length !== 0 ? (
                slice.map((x, index) => (
                  <tr key={x.id}>
                    <td>{(safePage - 1) * 10 + index + 1}</td>
                    <td>{x.event_name}</td>
                    <td>
                      <img
                        src={x.event_image}
                        onError={(e) => (e.currentTarget.src = srxc)}
                        width="48"
                        height="48"
                        alt={x.event_name}
                        style={{ borderRadius: 8, objectFit: "cover" }}
                      />
                    </td>
                    <td>{x.event_date}</td>
                    <td>{x.event_time}</td>
                    <td>{x.event_location}</td>
                    <td style={{ whiteSpace: "nowrap", verticalAlign: "middle" }}>
                      <div className="list-actions">
                        <button
                          type="button"
                          className="list-btn list-btn-view"
                          onClick={() => Update(x.id)}
                        >
                          View
                        </button>
                        <button
                          type="button"
                          className="list-btn list-btn-view"
                          onClick={() => Updatee(x.id)}
                        >
                          Images
                        </button>
                        <Link
                          to={"/admin/UpdateEvent/" + x.id}
                          className="list-btn list-btn-edit"
                        >
                          Edit
                        </Link>
                        <button
                          type="button"
                          className="list-btn list-btn-danger"
                          onClick={() => handledelete(x.id)}
                        >
                          Delete
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td className="list-empty" colSpan="7">
                    {search
                      ? "No events match your search"
                      : "No data found to display."}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
        <ListPagination
          page={safePage}
          totalPages={totalPages}
          total={total}
          onPageChange={setPage}
        />
      </div>
    </div>
  );
};

export default EventList;
