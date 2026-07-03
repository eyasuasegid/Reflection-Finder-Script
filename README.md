# 🔍 Reflection Finder Script

A powerful Bash tool for detecting **reflected parameters** in web applications.

It replaces query parameters with unique payloads, sends HTTP requests, and identifies which parameters are reflected in responses — useful for reconnaissance and pre-XSS discovery.

---

## ⚡ Features

- Detects parameter reflection automatically
- Supports multiple parameters per URL
- Assigns unique payload per parameter
- Groups results per URL (clean structured output)
- Colored terminal output
- Optional file output (`-o`)
- Supports authenticated requests (`-H`)
- Works with large URL lists
- Fast `curl`-based scanning

---

## 📦 Requirements

Make sure you have:

- `bash`
- `curl`
- `grep`

---

## 🚀 Usage

### Basic Scan

```bash
chmod +x reflect.sh
./reflect.sh -i urls.txt
```
### Save Output to File
```bash
./reflect.sh -i urls.txt -o results.txt
```
- Output is shown in terminal
- Clean report is saved to file (no colors)
### Authenticated Scan (Headers)

Use -H for authenticated or session-based targets.
```bash
./reflect.sh -i urls.txt -H "Cookie: session=abc123"
```
### Multiple Headers

You can pass multiple headers:
```bash
./reflect.sh -i urls.txt \
-H "Authorization: Bearer YOUR_TOKEN" \
-H "Content-Type: application/json" \
-H "Cookie: session=abcd1234"
```
