import React, { useEffect, useMemo, useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import srxc from "../assets/img/propic.png";
import { Link } from "react-router-dom";
import ListToolbar, { matchesSearch } from "../components/ListToolbar";
import ListPagination, { paginate } from "../components/ListPagination";

function Mainsponser(props) {
  const [sponser, setSponser] = useState([]);
  const [render, setRender] = useState(true);
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);

  useEffect(() => {
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/member/main_sponser", {
        role: "main_sponser",
        id: "",
      })
      .then((res) => {
        setSponser(res.data.response.data.info || []);
      })
      .catch(() => setSponser([]));
  }, [render]);

  const filtered = useMemo(
    () =>
      (sponser || []).filter((x) =>
        matchesSearch(x, search, [
          "sponser_name",
          "sponser_contact",
          "sponser_email",
          "sponser_location",
        ])
      ),
    [sponser, search]
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
    props.history.push("./Mainsponsersinle?id=" + id);
  }

  const Delete = (id) => {
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/deleteSponser", {
        id: id,
      })
      .then((res) => {
        if (res.data.response.data.info == "Sponsor deleted") setRender(!render);
      });
  };

  return (
    <div className="container-fluid p-3">
      <ListToolbar
        title="Main Sponsor List"
        search={search}
        onSearchChange={onSearchChange}
        placeholder="Search main sponsors by name, email, contact…"
        count={total}
        countLabel="sponsors"
      />
      <div className="list-table-card">
        <div className="table-responsive">
          <table className="table table-sm mb-0">
            <thead>
              <tr>
                <th>S.No</th>
                <th>Name</th>
                <th>Image</th>
                <th>Contact</th>
                <th>Email</th>
                <th>Location</th>
                <th style={{ minWidth: 180 }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {slice.length !== 0 ? (
                slice.map((x, i) => (
                  <tr key={x.id}>
                    <td>{(safePage - 1) * 10 + i + 1}</td>
                    <td style={{ textTransform: "capitalize" }}>
                      {x.sponser_name}
                    </td>
                    <td>
                      <img
                        src={x.sponser_image}
                        onError={(e) => (e.currentTarget.src = srxc)}
                        width="48"
                        height="40"
                        alt=""
                        style={{ borderRadius: 8, objectFit: "cover" }}
                      />
                    </td>
                    <td>{x.sponser_contact}</td>
                    <td>{x.sponser_email}</td>
                    <td style={{ textTransform: "capitalize" }}>
                      {x.sponser_location}
                    </td>
                    <td style={{ whiteSpace: "nowrap", verticalAlign: "middle" }}>
                      <div className="list-actions">
                        <button
                          type="button"
                          className="list-btn list-btn-view"
                          onClick={() => Update(x.id)}
                        >
                          View
                        </button>
                        <Link
                          to={"/admin/EditSponser/main_sponser/" + x.id}
                          className="list-btn list-btn-edit"
                        >
                          Edit
                        </Link>
                        <button
                          type="button"
                          className="list-btn list-btn-danger"
                          onClick={() => Delete(x.id)}
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
                      ? "No sponsors match your search"
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
}

export default Mainsponser;
