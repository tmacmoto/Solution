#!/bin/bash

# ----------------------------------------------------------
# Create a virtual environment with Python >= 3.9
# Install dependencies (requirements.txt)
# ----------------------------------------------------------

echo "Checking Python version..."

# 1. Ensure python3 exists
if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3 is not installed. Please install Python 3.9+."
    exit 1
fi

# 2. Check Python version >= 3.9
PY_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
MAJ=$(echo $PY_VER | cut -d. -f1)
MIN=$(echo $PY_VER | cut -d. -f2)

if (( MAJ < 3 )) || (( MAJ == 3 && MIN < 9 )); then
    echo "Python version $PY_VER is below required version 3.9."
    exit 1
fi

echo "Python version $PY_VER detected (>= 3.9)."
# 3. Prefer python3.9 if available
if command -v python3.9 >/dev/null 2>&1; then
    PYBIN="python3.9"
else
    PYBIN="python3"
    echo "python3.9 not found. Using python3 ($PY_VER)."
fi

echo "Using Python interpreter: $PYBIN"

# 4. Create virtual environment
echo "Creating virtual environment 'venv'..."
$PYBIN -m venv venv

# 5. Activate venv
echo "Activating virtual environment..."
source venv/bin/activate

# 6. Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# 7. Install requirements
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install -r requirements.txt
else
    echo "requirements.txt not found in this directory."
    exit 1
fi

echo ""
echo "Environment setup complete!"
echo "To activate the environment later, run:"
echo "    source venv/bin/activate"
echo ""
echo "Then launch the notebook with:"
echo "    jupyter notebook solution.ipynb"
