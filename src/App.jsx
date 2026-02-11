import { useState, useEffect, useRef } from "react";
import { PRODUCTS, getRecommendedLabel, getMaxLabel } from "./data/products";

function formatTime(seconds) {
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  const s = seconds % 60;
  return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
}

function getProgress(seconds, product) {
  return Math.min(seconds / (product.maxMinutes * 60), 1);
}

function getStatusColor(progress) {
  if (progress < 0.5) return "#6FCF97";
  if (progress < 0.75) return "#F2C94C";
  if (progress < 0.9) return "#F2994A";
  return "#EB5757";
}

function getStatusMessage(progress, running) {
  if (!running && progress === 0) return "Ready when you are! \uD83D\uDC81\u200D\u2640\uFE0F";
  if (progress < 0.25) return "Fresh & comfy \u2728";
  if (progress < 0.5) return "Cruisin' along \uD83D\uDE0E";
  if (progress < 0.75) return "Past the halfway mark \u23F0";
  if (progress < 0.9) return "Getting up there... \uD83D\uDC40";
  return "Time to change! \uD83D\uDEA8";
}

function formatTimestamp(dt) {
  const hour = dt.getHours() > 12 ? dt.getHours() - 12 : dt.getHours() === 0 ? 12 : dt.getHours();
  const minute = String(dt.getMinutes()).padStart(2, "0");
  const period = dt.getHours() >= 12 ? "PM" : "AM";
  return `${dt.getMonth() + 1}/${dt.getDate()}, ${hour}:${minute} ${period}`;
}

const HISTORY_KEY = "tin_history";

function loadHistory() {
  try {
    return JSON.parse(localStorage.getItem(HISTORY_KEY)) || [];
  } catch {
    return [];
  }
}

function saveHistory(history) {
  localStorage.setItem(HISTORY_KEY, JSON.stringify(history));
}

export default function App() {
  const [selectedProduct, setSelectedProduct] = useState(PRODUCTS[1]); // Tampon default
  const [seconds, setSeconds] = useState(0);
  const [running, setRunning] = useState(false);
  const [history, setHistory] = useState(loadHistory);
  const intervalRef = useRef(null);

  useEffect(() => {
    if (running) {
      intervalRef.current = setInterval(() => {
        setSeconds((s) => s + 1);
      }, 1000);
    } else {
      clearInterval(intervalRef.current);
    }
    return () => clearInterval(intervalRef.current);
  }, [running]);

  const progress = getProgress(seconds, selectedProduct);
  const statusColor = getStatusColor(progress);
  const statusMessage = getStatusMessage(progress, running);

  const circleRadius = 90;
  const circumference = 2 * Math.PI * circleRadius;
  const strokeDashoffset = circumference * (1 - progress);

  const handlePress = () => {
    if (running) {
      const newHistory = [
        {
          productId: selectedProduct.id,
          label: selectedProduct.label,
          duration: seconds,
          timestamp: formatTimestamp(new Date()),
        },
        ...history.slice(0, 4),
      ];
      setHistory(newHistory);
      saveHistory(newHistory);
      setRunning(false);
      setSeconds(0);
    } else {
      setRunning(true);
    }
  };

  return (
    <>
      {/* Header */}
      <div className="header">
        <h1>Tampon In? ⏱️</h1>
        <p>Track it. Change it. Feel great.</p>
      </div>

      {/* Product Selector */}
      <div className="product-selector">
        {PRODUCTS.map((p) => (
          <button
            key={p.id}
            className={`product-btn${selectedProduct.id === p.id ? " selected" : ""}${running && selectedProduct.id !== p.id ? " disabled" : ""}`}
            onClick={() => {
              if (!running) setSelectedProduct(p);
            }}
          >
            {p.label}
          </button>
        ))}
      </div>

      {/* Timer Circle */}
      <div className="timer-container">
        <svg width="220" height="220" viewBox="0 0 220 220">
          <circle
            cx="110"
            cy="110"
            r={circleRadius}
            fill="none"
            stroke="#F0D0DA"
            strokeWidth="12"
          />
          <circle
            cx="110"
            cy="110"
            r={circleRadius}
            fill="none"
            stroke={statusColor}
            strokeWidth="12"
            strokeLinecap="round"
            strokeDasharray={circumference}
            strokeDashoffset={strokeDashoffset}
            transform="rotate(-90 110 110)"
            style={{
              transition: "stroke-dashoffset 1s linear, stroke 0.5s ease",
            }}
          />
        </svg>
        <div className="timer-text">
          <div className="time">{formatTime(seconds)}</div>
        </div>
      </div>

      {/* Info Chips */}
      <div className="info-chips">
        <div className="info-chip">
          <div className="label">Recommended</div>
          <span className="value green">{getRecommendedLabel(selectedProduct)}</span>
        </div>
        <div className="info-chip">
          <div className="label">Maximum</div>
          <span className="value red">{getMaxLabel(selectedProduct)}</span>
        </div>
      </div>

      {/* Status Message */}
      <div className="status-message">{statusMessage}</div>

      {/* Big Button */}
      <button
        className={`big-button ${running ? "stop" : "start"}`}
        onClick={handlePress}
      >
        <span className="emoji">{running ? "🔄" : "▶️"}</span>
        <span>{running ? "CHANGED!" : "START"}</span>
      </button>

      {/* History */}
      {history.length > 0 && (
        <div className="history">
          <h3>Recent Changes</h3>
          {history.map((entry, i) => (
            <div key={i} className="history-item">
              <span className="product-name">{entry.label}</span>
              <span className="duration">{formatTime(entry.duration)}</span>
              <span className="timestamp">{entry.timestamp}</span>
            </div>
          ))}
        </div>
      )}

      {/* Footer Tip */}
      <div className="footer-tip">
        💡 Tip: Change times vary by product. Always follow your doctor's advice.
      </div>
    </>
  );
}
