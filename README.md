# 🪪 Digital Fayda Wallet – Secure ID for Seamless Services

## 👥 Contributors

- Marsilas Wondimagegnehu
- Melat Mekonnen

---

## 📘 Project Synopsis

### 🔍 Problem Statement

Ethiopian citizens often rely on **physical Fayda ID cards** to access basic services like banking, telecom, and government offices. These cards can be easily forgotten, lost, or damaged — and there's currently **no secure and user-friendly digital alternative**. Institutions also lack a fast, verifiable, and privacy-respecting way to confirm ID ownership in real time.

---

### 💡 Planned Solution

We are building a **mobile wallet app** that allows users to store their Fayda ID digitally on their phone, protected by biometric login or PIN. The app generates a **secure QR code** that banks or institutions can scan to verify the user.

To enhance functionality and trust, we are adding:

- **Digital consent**: Users approve or deny each access attempt
- **Blockchain-style verification**: Each scan generates a verifiable hash stored in a tamper-proof log
- **Multi-ID support**: Store not just Fayda, but other essential IDs like driver’s license

---

### 🎯 Expected Outcome

By the end of the hackathon, we expect to deliver:

- A functional mobile app that:

  - Stores Fayda ID data securely
  - Displays encrypted QR for verification
  - Uses biometric/PIN login for access
  - Supports digital consent and logging

- A working web verifier portal that:
  - Scans the QR code
  - Displays verified data from backend
  - Simulates ID verification

---

### 🪪 Fayda’s Role

Fayda is at the center of our solution. We are building a secure, accessible, and scalable interface around the Fayda ID system to:

- Promote **digital adoption** of national ID
- Enable secure and **real-time verification**
- Increase **citizen trust** in government-issued IDs
- Lay a foundation for **future integrations** (healthcare, education, elections)

This directly supports Ethiopia’s national goal of digital transformation and expands the usability of Fayda in everyday life.

---

## 🛠️ Tech Stack

| Component             | Technology                            |
| --------------------- | ------------------------------------- |
| Mobile App            | Flutter (Dart), flutter_barcode_sdk   |
| Backend & Auth        | Firebase (Auth, Firestore, Functions) |
| Encryption            | AES encryption, SHA256 for hashing    |
| Blockchain Simulation | Local hash-based verification ledger  |
| Multi-ID Structure    | JSON + Firestore schema design        |
| Digital Consent Logs  | Firestore logging + real-time UI      |
| Biometric Auth        | Flutter biometric plugins             |
| UI/UX Prototyping     | Figma                                 |
| Version Control       | Git + GitHub                          |

---
