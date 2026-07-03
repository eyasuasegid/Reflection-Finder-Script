# 🔍 Reflection Finder Script

A Bash-based automation tool for detecting **parameter reflection vulnerabilities** in web applications.

It replaces query parameters with unique payloads, sends requests, and identifies which parameters are reflected in the HTTP response.

---

## ⚡ Features

- Detects reflected parameters automatically
- Supports multiple parameters per URL
- Assigns unique payloads per parameter
- Groups results per URL (clean output)
- Colored terminal output for readability
- Saves results to file (optional `-o`)
- Works with large URL lists
- Fast `curl`-based scanning

---

## 📦 Requirements

Make sure the following tools are installed:

- `bash`
- `curl`
- `grep`

---

## 🚀 Usage

### Basic usage (screen output only)

```bash
chmod +x reflect.sh
./reflect.sh -i urls.txt
