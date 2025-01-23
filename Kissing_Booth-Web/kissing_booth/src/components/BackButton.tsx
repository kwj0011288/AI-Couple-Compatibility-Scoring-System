import React from "react";
import ChevronLeftIcon from "@mui/icons-material/ChevronLeft";

interface BackButtonProps {
    onClick: () => void; // Callback function for button click
}

const BackButton: React.FC<BackButtonProps> = ({ onClick }) => {
    return (
        <button
            onClick={onClick}
            style={{
                backgroundColor: "rgba(244, 244, 250, 1)",
                color: "#000",
                padding: "15px",
                border: "none",
                borderRadius: "50%",
                cursor: "pointer",
                transition: "background-color 0.3s ease",
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                width: "60px",
                height: "60px",


            }}
            className="hover:opacity-90 focus:ring-2 focus:ring-offset-2 focus:outline-none"
        >
            <ChevronLeftIcon style={{ color: "#000", fontSize: "20px" }} />
        </button>
    );
};

export default BackButton;
