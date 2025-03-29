---
title: "esp-idf-sbom IDE intergration"
author: "Frantisek Hrbata"
date: "March 31, 2025"
header-includes: |
  <style>
    .reveal {
        background-image: url('images/logo.png');
        background-size: 20%;
        background-position: right 20px top 20px; /* Moves the logo to the top-right */
        background-repeat: no-repeat;
    }
    .reveal pre code {
      background-color: #111111;
      max-height: 400px; /* Adjust this as needed */
      overflow: auto !important;
      display: block;
      white-space: pre; /* Ensure text wraps correctly */
    }
  </style>
---

## overview

::: incremental
- [esp-idf-sbom homepage on github](https://github.com/espressif/esp-idf-sbom)
- Espressif's utility for managing SBOM for ESP-IDF applications
    - creates an SBOM in the SPDX format
    - checks the created SBOM for potential vulnerabilities
    - other features
:::


## installation

::: incremental
- not yet integrated into ESP-IDF
- needs to be installed using pip
  ```
  $ pip install esp-idf-sbom
  ```
- can be executed as a Python module
  ```
  $ python -m esp_idf_sbom
  ```
- or as a console script
  ```
  $ esp-idf-sbom
  ```
:::

## generating application SBOM

::: incremental
- depends on build artifacts
- create default SPDX SBOM for application
  ```
  $ esp-idf-sbom create -o sbom.spdx build/project_description.json
  ```
- create minimal SPDX SBOM for application
  ```
  $ esp-idf-sbom create --rem-config --rem-unused -o sbom.spdx build/project_description.json
  ```
:::

## checking application SBOM for vulnerabilities

::: incremental
- two ways to check the application SBOM for vulnerabilities
- default using NVD REST API
  ```
  $ esp-idf-sbom check sbom.spdx
  ```
- using NVD mirror in git repository
  ```
  $ esp-idf-sbom check --local-db sbom.spdx
  ```
- outcome is vulnerability scan report
:::

## report formats

- report can be created in various formats
  - table(default)
  - json
  - csv
  - markdown

## generating report in json format

- using NVD REST API
  ```
  $ esp-idf-sbom check --format json -o report.json sbom.spdx
  ```
- using local NVD mirror
  ```
  $ esp-idf-sbom check --local-db --format json -o report.json sbom.spdx
  ```

## json report format

::: incremental
- metadata information
  - date, database, tool and project information
- CVE summary
  - overview on identified vulnerabilities
  - sorted from critical to low CVEs
- records
  - detailed information about found vulnerabilities
  - contains component name, CVE score, description and others
:::

## json report metadata

```json
{
  "date": "2025-03-30T17:11:04Z",
  "database": "NATIONAL VULNERABILITY DATABASE MIRROR (https://github.com/espressif/esp-nvd-mirror.git@f68179e4ff6ebaafdc88efd7d3f2c4e909400335)",
  "tool": {
    "name": "esp-idf-sbom",
    "version": "0.20.1",
    "cmdl": "/home/fhrbata/.espressif/python_env/idf5.5_py3.12_env/bin/esp-idf-sbom check --local-db --format json -o report.json sbom.spdx"
  },
  "project": {
    "name": "project-hello_world",
    "version": "v5.5-dev-2715-ga45d713b03fd"
  }
}
```

## json report cve summary

```json
{
  "cves_summary": {
    "critical": {
      "count": 3,
      "cves": [
        "CVE-2021-31571",
        "CVE-2021-31572",
        "CVE-2021-32020"
      ],
      "packages": [
        "freertos"
      ]
    },
    "high": {
      "count": 0,
      "cves": [],
      "packages": []
    },
    "medium": {
      "count": 0,
      "cves": [],
      "packages": []
    },
    "low": {
      "count": 0,
      "cves": [],
      "packages": []
    },
    "unknown": {
      "count": 0,
      "cves": [],
      "packages": []
    },
    "total_cves_count": 3,
    "packages_count": 28,
    "all_cves": [
      "CVE-2021-31571",
      "CVE-2021-31572",
      "CVE-2021-32020"
    ],
    "all_packages": [
      "freertos"
    ]
  }
}
```

## json report record

::: incremental
- each record has a `vulnerable` key
  - YES
  - MAYBE
  - EXCLUDED
  - NO
  - SKIPPED
:::

## vulnerable record

```json
{
    "vulnerable": "YES",
    "pkg_name": "freertos",
    "pkg_version": "10.5.1",
    "cve_id": "CVE-2021-31571",
    "cvss_base_score": "9.8",
    "cvss_base_severity": "CRITICAL",
    "cvss_version": "3.1",
    "cvss_vector_string": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H",
    "cpe": "cpe:2.3:o:amazon:freertos:10.0.0:*:*:*:*:*:*:*",
    "keyword": "", 
    "cve_link": "https://nvd.nist.gov/vuln/detail/CVE-2021-31571",
    "cve_desc": "The kernel in Amazon Web Services FreeRTOS before 10.4.3 has an integer overflow in queue.c for queue creation.",
    "exclude_reason": "",
    "status": "Modified"
}
```

## excluded vulnerable record
```json
{
    "vulnerable": "EXCLUDED",
    "pkg_name": "freertos",
    "pkg_version": "10.5.1",
    "cve_id": "CVE-2024-28115",
    "cvss_base_score": "8.8",
    "cvss_base_severity": "HIGH",
    "cvss_version": "3.1",
    "cvss_vector_string": "CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:C/C:H/I:H/A:H",
    "cpe": "cpe:2.3:o:amazon:freertos:10.0.0:*:*:*:*:*:*:*",
    "keyword": "",
    "cve_link": "https://nvd.nist.gov/vuln/detail/CVE-2024-28115",
    "cve_desc": "FreeRTOS is a real-time operating system for microcontrollers. FreeRTOS Kernel versions through 10.6.1 do not sufficiently protect against local privilege escalation via Return Oriented Programming techniques should a vulnerability exist that allows code injection and execution. These issues affect ARMv7-M MPU ports, and ARMv8-M ports with Memory Protected Unit (MPU) support enabled (i.e. `configENABLE_MPU` set to 1). These issues are fixed in version 10.6.2 with a new MPU wrapper. ",
    "exclude_reason": "Affects only ARMv7-M MPU ports, and ARMv8-M ports with Memory Protected Unit (MPU) support enabled",
    "status": "Modified"
}
```

# demo

# questions
