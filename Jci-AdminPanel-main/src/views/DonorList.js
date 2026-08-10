import React, { useEffect, useMemo, useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import ListToolbar, { matchesSearch } from "../components/ListToolbar";
import ListPagination, { paginate } from "../components/ListPagination";

function DonorList() {
  const [donor, setDonor] = useState([]);
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/listRequest")
      .then((res) => {
        setDonor(res.data.response.data.info || []);
      })
      .catch(() => setDonor([]));
  }, []);

  const filtered = useMemo(
    () =>
      (donor || []).filter((x) =>
        matchesSearch(x, search, [
          "NameOfPatient",
          "BloodGroup",
          "Hospital_name",
          "location",
          "Contact",
          "Attender",
          "created_by",
        ])
      ),
    [donor, search]
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

  return (
    <div className="container-fluid p-3">
      <ListToolbar
        title="Blood Request List"
        search={search}
        onSearchChange={onSearchChange}
        placeholder="Search by patient, blood group, hospital…"
        count={total}
        countLabel="requests"
      />
      <div className="list-table-card">
        <div className="table-responsive">
          <table className="table table-sm mb-0">
            <thead>
              <tr>
                <th>S.No</th>
                <th>Patient</th>
                <th>Blood Group</th>
                <th>Units</th>
                <th>Hospital</th>
                <th>Location</th>
                <th>Contact</th>
                <th>Attender</th>
                <th>Date</th>
                <th>Created By</th>
              </tr>
            </thead>
            <tbody>
              {slice.length !== 0 ? (
                slice.map((x, index) => (
                  <tr key={x.id || index}>
                    <td>{(safePage - 1) * 10 + index + 1}</td>
                    <td style={{ textTransform: "capitalize" }}>
                      {x.NameOfPatient}
                    </td>
                    <td>{x.BloodGroup}</td>
                    <td>{x.NoOfUnits}</td>
                    <td style={{ textTransform: "capitalize" }}>
                      {x.Hospital_name}
                    </td>
                    <td style={{ textTransform: "capitalize" }}>{x.location}</td>
                    <td>{x.Contact}</td>
                    <td style={{ textTransform: "capitalize" }}>{x.Attender}</td>
                    <td>{x.createdAt}</td>
                    <td style={{ textTransform: "capitalize" }}>
                      {x.created_by}
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td className="list-empty" colSpan="10">
                    {search
                      ? "No requests match your search"
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

export default DonorList;
