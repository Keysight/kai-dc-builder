#!/bin/bash

# pull-modules.sh
# Downloads Python module version information and wheel files from DSE server
#
# Usage:
#   pull-modules.sh <dse_base_url> <destination_dir>
#
# Arguments:
#   dse_base_url    - Base URL of DSE server (e.g., https://localhost:443)
#   destination_dir - Directory where modules will be downloaded
#
# Example:
#   ./bin/pull-modules.sh https://localhost:443 /path/to/storage/notebooks/modules

set -e

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dse_base_url> <destination_dir>"
    echo ""
    echo "Arguments:"
    echo "  dse_base_url    - Base URL of DSE server (e.g., https://localhost:443)"
    echo "  destination_dir - Directory where modules will be downloaded"
    exit 1
fi

DSE_BASE_URL="$1"
DEST_DIR="$2"

# Construct URLs
CLIENT_LIB_PATH="${DSE_BASE_URL}/assets/automation/client-lib"
VERSION_TXT_URL="${CLIENT_LIB_PATH}/version.txt"

echo "Downloading Python modules from DSE server..."
echo "  Base URL: ${DSE_BASE_URL}"
echo "  Destination: ${DEST_DIR}"
echo ""

# Create destination directory if it doesn't exist
mkdir -p "${DEST_DIR}"

# Download version.txt
echo "Downloading version.txt..."
VERSION_TXT_FILE="${DEST_DIR}/version.txt"
if curl -kfsSL -o "${VERSION_TXT_FILE}" "${VERSION_TXT_URL}"; then
    echo "  ✓ version.txt downloaded successfully"
else
    echo "  ✗ Failed to download version.txt from ${VERSION_TXT_URL}"
    exit 1
fi

# Parse version.txt to extract version numbers
echo ""
echo "Parsing version information..."

# Source the file directly to initialize variables (format: KEY=value)
source "${VERSION_TXT_FILE}"

# Validate that we got all versions
if [ -z "$MODELS_VERSION" ] || [ -z "$CLIENT_VERSION" ] || [ -z "$CHAKRA_VERSION" ]; then
    echo "  ✗ Failed to parse version.txt. Contents:"
    cat "${VERSION_TXT_FILE}"
    exit 1
fi

echo "  MODELS_VERSION: ${MODELS_VERSION}"
echo "  CLIENT_VERSION: ${CLIENT_VERSION}"
echo "  CHAKRA_VERSION: ${CHAKRA_VERSION}"

# Construct wheel filenames
DSE_MODELS_FILE="keysight_dse_models-${MODELS_VERSION}-py3-none-any.whl"
DSE_CLIENT_FILE="keysight_dse_client-${CLIENT_VERSION}-py3-none-any.whl"
CHAKRA_FILE="keysight_chakra-${CHAKRA_VERSION}-py3-none-any.whl"

# Construct download URLs
DSE_MODELS_URL="${CLIENT_LIB_PATH}/${DSE_MODELS_FILE}"
DSE_CLIENT_URL="${CLIENT_LIB_PATH}/${DSE_CLIENT_FILE}"
CHAKRA_URL="${CLIENT_LIB_PATH}/${CHAKRA_FILE}"

# Download wheel files
echo ""
echo "Downloading Python wheel files..."

# Download keysight_dse_models
echo -n "  - ${DSE_MODELS_FILE} ... "
if curl -kfsSL -o "${DEST_DIR}/${DSE_MODELS_FILE}" "${DSE_MODELS_URL}"; then
    echo "complete"
else
    echo "FAILED"
    echo "    URL: ${DSE_MODELS_URL}"
    exit 1
fi

# Download keysight_dse_client
echo -n "  - ${DSE_CLIENT_FILE} ... "
if curl -kfsSL -o "${DEST_DIR}/${DSE_CLIENT_FILE}" "${DSE_CLIENT_URL}"; then
    echo "complete"
else
    echo "FAILED"
    echo "    URL: ${DSE_CLIENT_URL}"
    exit 1
fi

# Download keysight_chakra
echo -n "  - ${CHAKRA_FILE} ... "
if curl -kfsSL -o "${DEST_DIR}/${CHAKRA_FILE}" "${CHAKRA_URL}"; then
    echo "complete"
else
    echo "FAILED"
    echo "    URL: ${CHAKRA_URL}"
    exit 1
fi

echo ""
echo "Download complete. Modules saved to: ${DEST_DIR}"
