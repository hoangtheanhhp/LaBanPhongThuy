/**
 * Tra Cứu Bát Quái Phong Thuỷ Trực Tuyến - Logic Ứng Dụng
 */

document.addEventListener("DOMContentLoaded", () => {
  initTabs();
  initCungCalculator();
  initLuBanRuler();
  initIChing();
  initSatKhi();
  initTamYeu();
});

// ── 1. CHUYỂN TAB ──
function initTabs() {
  const tabs = document.querySelectorAll(".tab-btn");
  const contents = document.querySelectorAll(".tab-content");

  tabs.forEach(tab => {
    tab.addEventListener("click", () => {
      tabs.forEach(t => t.classList.remove("active"));
      contents.forEach(c => c.classList.remove("active"));

      tab.classList.add("active");
      const targetId = tab.getAttribute("data-tab");
      const targetContent = document.getElementById(targetId);
      if (targetContent) {
        targetContent.classList.add("active");
      }
    });
  });
}

// ── 2. CÔNG CỤ TÍNH CUNG PHI BÁT TRẠCH ──
function initCungCalculator() {
  const yearInput = document.getElementById("birthYear");
  const genderBtns = document.querySelectorAll(".gender-btn");
  const calcBtn = document.getElementById("calcCungBtn");
  const resultBox = document.getElementById("cungResultBox");

  let selectedGender = "male";

  genderBtns.forEach(btn => {
    btn.addEventListener("click", () => {
      genderBtns.forEach(b => b.classList.remove("active"));
      btn.classList.add("active");
      selectedGender = btn.getAttribute("data-gender");
    });
  });

  calcBtn.addEventListener("click", () => {
    const year = parseInt(yearInput.value);
    if (isNaN(year) || year < 1920 || year > 2060) {
      alert("Vui lòng nhập năm sinh hợp lệ (từ 1920 đến 2060)");
      return;
    }

    const cung = calculateCungPhi(year, selectedGender);
    renderCungResult(cung, year, selectedGender);
  });
}

function calculateCungPhi(birthYear, gender) {
  let sum = birthYear % 100;
  while (sum >= 10) {
    sum = Math.floor(sum / 10) + (sum % 10);
  }

  let quaiNumber;
  if (birthYear < 2000) {
    if (gender === "male") {
      quaiNumber = (10 - sum) % 9;
      if (quaiNumber === 0) quaiNumber = 9;
    } else {
      quaiNumber = (5 + sum) % 9;
      if (quaiNumber === 0) quaiNumber = 9;
    }
  } else {
    if (gender === "male") {
      quaiNumber = (9 - sum) % 9;
      if (quaiNumber === 0) quaiNumber = 9;
    } else {
      quaiNumber = (6 + sum) % 9;
      if (quaiNumber === 0) quaiNumber = 9;
    }
  }

  // Quái 5: Nam -> Khôn (2), Nữ -> Cấn (8)
  if (quaiNumber === 5) {
    quaiNumber = (gender === "male") ? 2 : 8;
  }

  // Map số quái sang dữ liệu Bát Quái
  const mapping = {
    1: "kham",
    2: "khon",
    3: "chan",
    4: "ton",
    6: "can",
    7: "doai",
    8: "can_tho",
    9: "ly"
  };

  const cungId = mapping[quaiNumber];
  return FENG_SHUI_DATA.bagua.find(b => b.id === cungId);
}

function renderCungResult(cung, year, gender) {
  const resultBox = document.getElementById("cungResultBox");
  if (!cung || !resultBox) return;

  const genderText = gender === "male" ? "Nam" : "Nữ";
  
  let html = `
    <div class="result-header">
      <div>
        <div style="font-size:12px; color:var(--text-muted);">Năm sinh: ${year} (${genderText})</div>
        <div style="font-size:18px; font-weight:800; color:var(--wood-accent); margin-top:2px;">
          ${cung.symbol} Cung ${cung.name} (${cung.element})
        </div>
      </div>
      <div class="cung-badge">${cung.group}</div>
    </div>
    
    <div style="font-size:12.5px; color:var(--text-secondary); margin-bottom:12px;">
      ${cung.desc}
    </div>

    <div style="font-size:13px; font-weight:700; color:#81C784; margin-top:14px;">✦ 4 HƯỚNG CÁT (NÊN CHỌN)</div>
    <div class="dir-grid">
  `;

  cung.goodDirs.forEach(d => {
    html += `
      <div class="dir-card good">
        <div class="dir-name">
          <span>${d.name}</span>
          <span style="font-size:10px; color:#81C784;">CÁT</span>
        </div>
        <div class="dir-target">${d.dir}</div>
        <div class="dir-desc">${d.desc}</div>
      </div>
    `;
  });

  html += `</div>
    <div style="font-size:13px; font-weight:700; color:#E57373; margin-top:16px;">✦ 4 HƯỚNG HUNG (NÊN TRÁNH)</div>
    <div class="dir-grid">
  `;

  cung.badDirs.forEach(d => {
    html += `
      <div class="dir-card bad">
        <div class="dir-name">
          <span>${d.name}</span>
          <span style="font-size:10px; color:#E57373;">HUNG</span>
        </div>
        <div class="dir-target">${d.dir}</div>
        <div class="dir-desc">${d.desc}</div>
      </div>
    `;
  });

  html += `</div>`;

  resultBox.innerHTML = html;
  resultBox.classList.add("visible");
  resultBox.scrollIntoView({ behavior: "smooth", block: "nearest" });
}

// ── 3. THƯỚC LỖ BAN TRỰC TUYẾN ──
function initLuBanRuler() {
  let currentRulerType = "522";
  const numInput = document.getElementById("rulerInput");
  const slider = document.getElementById("rulerSlider");
  const tabs = document.querySelectorAll(".ruler-tab");

  tabs.forEach(tab => {
    tab.addEventListener("click", () => {
      tabs.forEach(t => t.classList.remove("active"));
      tab.classList.add("active");
      currentRulerType = tab.getAttribute("data-ruler");
      updateRuler(parseFloat(numInput.value), currentRulerType);
    });
  });

  numInput.addEventListener("input", () => {
    let val = parseFloat(numInput.value) || 0;
    if (val < 0) val = 0;
    if (val > 500) val = 500;
    slider.value = val;
    updateRuler(val, currentRulerType);
  });

  slider.addEventListener("input", () => {
    numInput.value = slider.value;
    updateRuler(parseFloat(slider.value), currentRulerType);
  });

  // Khởi tạo ban đầu ở 81 cm (Cung Tài/Quý Nhân cát lợi)
  updateRuler(81, currentRulerType);
}

function updateRuler(cm, rulerType) {
  const rulerDef = FENG_SHUI_DATA.luBanRulers.find(r => r.type === rulerType);
  if (!rulerDef) return;

  const unit = rulerDef.unitLength;
  const sectors = rulerDef.sectors;
  const numSectors = sectors.length;

  // Tính vị trí trong chu kỳ thước
  let remainder = cm % unit;
  if (remainder < 0) remainder += unit;

  const sectorIndex = Math.min(Math.floor((remainder / unit) * numSectors), numSectors - 1);
  const activeSector = sectors[sectorIndex];

  // Cập nhật giao diện
  const strip = document.getElementById("rulerStrip");
  const descBox = document.getElementById("rulerDesc");
  const usageText = document.getElementById("rulerUsage");

  if (usageText) {
    usageText.textContent = rulerDef.usage;
  }

  if (strip && descBox) {
    if (activeSector.isGood) {
      strip.className = "ruler-display-strip strip-good";
      strip.innerHTML = `✦ CUNG ${activeSector.name.toUpperCase()} (CÁT - TỐT) ✦`;
    } else {
      strip.className = "ruler-display-strip strip-bad";
      strip.innerHTML = `✖ CUNG ${activeSector.name.toUpperCase()} (HUNG - XẤU) ✖`;
    }

    descBox.innerHTML = `<strong>Ý nghĩa cung ${activeSector.name}:</strong> ${activeSector.desc}`;
  }
}

// ── 4. KINH DỊCH 64 QUẺ ──
function initIChing() {
  const container = document.getElementById("ichingGrid");
  const searchInput = document.getElementById("ichingSearch");
  const modal = document.getElementById("ichingModal");
  const closeBtn = document.getElementById("modalClose");

  if (!container) return;

  function renderList(list) {
    container.innerHTML = "";
    if (list.length === 0) {
      container.innerHTML = `<div style="grid-column: 1/-1; text-align:center; color:var(--text-muted); padding:20px;">Không tìm thấy quẻ phù hợp</div>`;
      return;
    }

    list.forEach(q => {
      const card = document.createElement("div");
      card.className = "iching-card";
      card.innerHTML = `
        <div class="iching-num">Quẻ ${q.number}</div>
        <div class="iching-sym">${q.symbol}</div>
        <div class="iching-name">${q.name}</div>
        <div style="font-size:10px; color:var(--text-muted); margin-top:2px;">${q.upper} / ${q.lower}</div>
      `;
      card.addEventListener("click", () => showIChingDetail(q));
      container.appendChild(card);
    });
  }

  function showIChingDetail(q) {
    const title = document.getElementById("modalTitle");
    const body = document.getElementById("modalBody");
    if (!title || !body) return;

    title.innerHTML = `${q.symbol} Quẻ số ${q.number}: ${q.name}`;
    body.innerHTML = `
      <div style="margin-bottom:12px;">
        <span class="cung-badge">${q.upper} thượng</span>
        <span class="cung-badge" style="margin-left:6px;">${q.lower} hạ</span>
      </div>
      <div style="margin-bottom:12px;">
        <div style="font-size:12px; font-weight:700; color:var(--wood-accent);">Ý NGHĨA THOÁN TỪ:</div>
        <div style="font-size:13px; color:var(--text-secondary); margin-top:4px; line-height:1.5;">${q.meaning}</div>
      </div>
      <div>
        <div style="font-size:12px; font-weight:700; color:#81C784;">ỨNG DỤNG PHONG THỦY NHÀ ĐẤT:</div>
        <div style="font-size:13px; color:var(--text-primary); margin-top:4px; line-height:1.5;">${q.fengShui}</div>
      </div>
    `;

    modal.classList.add("open");
  }

  closeBtn.addEventListener("click", () => modal.classList.remove("open"));
  modal.addEventListener("click", (e) => {
    if (e.target === modal) modal.classList.remove("open");
  });

  searchInput.addEventListener("input", (e) => {
    const term = e.target.value.toLowerCase().trim();
    const filtered = FENG_SHUI_DATA.iching.filter(q => 
      q.name.toLowerCase().includes(term) ||
      q.upper.toLowerCase().includes(term) ||
      q.lower.toLowerCase().includes(term) ||
      q.meaning.toLowerCase().includes(term) ||
      q.number.toString() === term
    );
    renderList(filtered);
  });

  renderList(FENG_SHUI_DATA.iching);
}

// ── 5. HÓA GIẢI SÁT KHÍ ──
function initSatKhi() {
  const container = document.getElementById("satKhiList");
  if (!container) return;

  let html = "";
  FENG_SHUI_DATA.satKhi.forEach((item, index) => {
    html += `
      <div class="accordion-item">
        <div class="accordion-header" onclick="toggleAccordion('sk-${index}')">
          <span>⚠️ ${item.name}</span>
          <span id="sk-arrow-${index}">▼</span>
        </div>
        <div class="accordion-body" id="sk-${index}">
          <div class="satkhi-danger"><strong>Tác hại:</strong> ${item.danger}</div>
          <div class="satkhi-cure"><strong>Cách hóa giải:</strong> ${item.solution}</div>
        </div>
      </div>
    `;
  });
  container.innerHTML = html;
}

window.toggleAccordion = function(id) {
  const el = document.getElementById(id);
  if (el) {
    el.style.display = (el.style.display === "none") ? "block" : "none";
  }
};

// ── 6. DƯƠNG TRẠCH TAM YẾU ──
function initTamYeu() {
  const table = document.getElementById("bepMappingTable");
  if (!table) return;

  let rows = "";
  FENG_SHUI_DATA.tamYeu.bepMapping.forEach(m => {
    rows += `
      <tr>
        <td style="padding:8px; border-bottom:1px solid rgba(90,77,65,0.3); font-weight:700; color:var(--wood-accent);">${m.cung}</td>
        <td style="padding:8px; border-bottom:1px solid rgba(90,77,65,0.3); color:#E57373; font-size:12px;">${m.toa}</td>
        <td style="padding:8px; border-bottom:1px solid rgba(90,77,65,0.3); color:#81C784; font-size:12px;">${m.huong}</td>
      </tr>
    `;
  });
  table.innerHTML = rows;
}
