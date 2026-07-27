import React, { useState, useEffect } from "react";
import axios from "axios";
import { ToastContainer, toast } from "react-toastify";

function CreateChannel() {
  const [pdf_name, setpdf_name] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  const [greenChannel, setChannel] = useState("");
  const [list, setPDFList] = useState([]);
  const [render, setRender] = useState(true);

  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);

    const data = {
      pdf_name: pdf_name,
      greenChannel: greenChannel,
    };
    const formdata = new FormData();
    Object.entries(data).map((data) => {
      data;
      formdata.append(data[0], data[1]);
    });

    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/uploadGreenChannelPdf",
        formdata
      )
      .then((res) => {
        setChannel("");
        setpdf_name("");
        toast.success(res.data.response.data.info);
        axios
          .get(process.env.REACT_APP_URL_ADMIN + "/member/greenChannel")
          .then((res) => {
            setPDFList(res.data.response.data.info);
          });
        setLoading(false);
      })
      .catch((err) => {
        if (
          err.response &&
          err.response.data &&
          err.response.data.error &&
          typeof err.response.data.error.message === "string"
        )
          if (err.response.data.error.message === "Authentication Failed") {
            localStorage.clear();
            window.location.reload();
          }
        setLoading(false);
        setIsError(true);
        toast.error("Failed to create channel!");
      });
    console.log("formdata", formdata);
  };
  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/greenChannel")
      .then((res) => {
        setPDFList(res.data.response.data.info);
      });
  }, [render]);
  return (
    <div>
      <div className="form-group">
        <label htmlFor="name">Enter PDF Name</label>
        <input
          type="text"
          className="form-control"
          id="pdf_name"
          placeholder="Enter name"
          value={pdf_name}
          onChange={(e) => setpdf_name(e.target.value)}
          required={true}
        />
        <label htmlFor="name">Green Channel</label>
        <input
          type="file"
          className="form-control"
          accept=".pdf"
          id="greenChannel"
          // value={greenChannel}
          onChange={(e) => {
            if (e.target.files) setChannel(e.target.files[0]);
          }}
          required={true}
        />
      </div>
      <ToastContainer />
      <button
        type="submit"
        className="btn btn-primary mt-3"
        onClick={handleSubmit}
        disabled={loading}
      >
        {loading ? "Loading..." : "Submit"}
      </button>

      <div className="container-fluid p-3">
        <table className="table table-sm mt-3">
          <thead className="thead-dark">
            <th>Id</th>
            <th>Name</th>
            <th>Download pdfs</th>
          </thead>
          <tbody>
            {Array.isArray(list) && list.length !== 0 ? (
              list.map((x, index) => (
                <tr>
                  <td>{++index}</td>
                  <td style={{ textTransform: "capitalize" }}>{x.pdf_name}</td>
                  <td>
                    <a
                      href={x.pdf_url}
                      target="_blank"
                      className="badge badge-success m-2"
                      style={{ cursor: "pointer" }}
                      download
                    >
                      <i className="bx bxs-download"></i> Download{" "}
                    </a>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td className="text-center" colSpan="4">
                  <b>No data found to display</b>
                </td>{" "}
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default CreateChannel;
