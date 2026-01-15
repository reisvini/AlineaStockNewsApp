#!/bin/bash
#
# Regenerate OpenAPI client using Apple's swift-openapi-generator
#

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
cd "$PROJECT_ROOT"

OPENAPI_SPEC="AlineaStockNews/openapi.json"
CONFIG_FILE="AlineaStockNews/openapi-generator-config.yaml"
OUTPUT_DIR="AlineaStockNews/Generated"

echo "🔄 Regenerating OpenAPI client code..."

# Check if required files exist
if [ ! -f "$OPENAPI_SPEC" ]; then
    echo "❌ Error: $OPENAPI_SPEC not found"
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: $CONFIG_FILE not found"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Install the generator if needed
if ! command -v swift-openapi-generator &> /dev/null; then
    echo "📦 Installing swift-openapi-generator..."
    cd codegen-tool
    swift build -c release
    GENERATOR="$(swift build -c release --show-bin-path)/swift-openapi-generator"
    cd ..
else
    GENERATOR="swift-openapi-generator"
fi

# Generate the client code
echo "✨ Generating client code from $OPENAPI_SPEC..."

"$GENERATOR" generate \
    --mode types \
    --mode client \
    --output-directory "$OUTPUT_DIR" \
    --config "$CONFIG_FILE" \
    "$OPENAPI_SPEC"

echo "✅ Code generation complete!"
echo "📝 Generated files in $OUTPUT_DIR/"
ls -lh "$OUTPUT_DIR"
