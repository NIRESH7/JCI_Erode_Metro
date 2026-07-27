import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { BrowserRouter as Router, Link, useLocation } from "react-router-dom";
function Mainsponsersinle(props) {
    function useQuery() {
        return new URLSearchParams(useLocation().search);
    }
    let query = useQuery();
    const [sponser, setSponser] = useState(null);

    useEffect(() => {
        const id = query.get("id");
        axios.post(process.env.REACT_APP_URL_ADMIN+"/member/main_sponser", { id }).then((res) => {
            setSponser(res.data.response.data.info);
        });
    }, []);
    return (
        <>
            <div>
                <div className="row g-0">
                    <div className="col-md-4">
                        <img src={sponser?.sponser_image} className="img-fluid rounded-start" alt={sponser?.sponser_name} />
                    </div>
                    <div className="col-md-8">
                        <div className="card-body">
                            <p className="card-title">
                                <span style={{ fontWeight: "bold" }}>Sponser Name: </span>
                                {sponser?.sponser_name}</p>
                            <p className="card-text">
                                <span style={{ fontWeight: "bold" }}>Sponser Email: </span>
                                {sponser?.sponser_email}</p>
                            <p className="card-text">
                                <span style={{ fontWeight: "bold" }}>Sponser Location: </span>
                                {sponser?.sponser_location}</p>
                            <p className="card-text">
                                <span style={{ fontWeight: "bold" }}>Sponser Website: </span>
                                {sponser?.sponser_website}</p>
                            <p className="card-text">
                                <span style={{ fontWeight: "bold" }}>Sponser Role: </span>
                                {sponser?.role}</p>

                        </div>
                    </div>
                    <div className="col-md-8">
                        <div className="card-body">
                            <p style={{ fontWeight: "bold" }}>Event Description</p>
                            <p className="card-text">{sponser?.sponser_description}</p>

                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
export default Mainsponsersinle;