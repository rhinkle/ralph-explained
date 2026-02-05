#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE_DIR="$SCRIPT_DIR/skills"
CONFIG_FILE="$SCRIPT_DIR/.ralph-config"

# Verify skills source directory exists
if [ ! -d "$SKILLS_SOURCE_DIR" ]; then
    echo "Error: Skills directory not found at $SKILLS_SOURCE_DIR"
    exit 1
fi

# Ask which AI CLI tool they will be using
echo "Which AI CLI tool will you be using?"
echo "1) Claude (Default)"
echo "2) Copilot"
echo "3) Gemini"
read -p "Enter your choice (1-3): " AI_TOOL_CHOICE

case $AI_TOOL_CHOICE in
    1|"")
        AI_TOOL="claude"
        AI_TOOL_CMD="claude --dangerously-skip-permissions"
        GLOBAL_SKILLS_DIR=~/.claude/skills
        LOCAL_SKILLS_SUBDIR=".claude/skills"
        echo "Using Claude CLI"
        ;;
    2)
        AI_TOOL="copilot"
        AI_TOOL_CMD="copilot --allow-all-tools"
        GLOBAL_SKILLS_DIR=~/.copilot/skills
        LOCAL_SKILLS_SUBDIR=".copilot/skills"
        echo "Using Copilot CLI"
        ;;
    3)
        AI_TOOL="gemini"
        AI_TOOL_CMD="gemini --yolo"
        GLOBAL_SKILLS_DIR=~/.gemini/skills
        LOCAL_SKILLS_SUBDIR=".gemini/skills"
        echo "Using Gemini CLI"
        ;;
    *)
        echo "Invalid choice. Defaulting to Claude."
        AI_TOOL="claude"
        AI_TOOL_CMD="claude --dangerously-skip-permissions"
        GLOBAL_SKILLS_DIR=~/.claude/skills
        LOCAL_SKILLS_SUBDIR=".claude/skills"
        ;;
esac

# Save the AI tool selection to config file
echo "AI_TOOL=$AI_TOOL" > "$CONFIG_FILE"
echo "AI_TOOL_CMD=\"$AI_TOOL_CMD\"" >> "$CONFIG_FILE"

# Ask user if they want a global install for skills or local project only
echo ""
echo "Where would you like to install the skills?"
echo "1) Global (available system-wide)"
echo "2) Local project only"
read -p "Enter your choice (1 or 2): " INSTALL_CHOICE

case $INSTALL_CHOICE in
    1)
        SKILLS_DIR="$GLOBAL_SKILLS_DIR"
        echo "Installing skills globally to $SKILLS_DIR"
        ;;
    2)
        SKILLS_DIR="$(pwd)/$LOCAL_SKILLS_SUBDIR"
        echo "Installing skills locally to $SKILLS_DIR"
        ;;
    *)
        echo "Invalid choice. Defaulting to local installation."
        SKILLS_DIR="$(pwd)/$LOCAL_SKILLS_SUBDIR"
        ;;
esac

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Track overwrite preference
OVERWRITE_ALL=false
SKIP_ALL=false

# Copy each skill from the skills source directory
for skill in "$SKILLS_SOURCE_DIR"/*; do
    if [ -d "$skill" ]; then
        skill_name=$(basename "$skill")
        target_path="$SKILLS_DIR/$skill_name"

        # Check if skill already exists
        if [ -d "$target_path" ]; then
            if [ "$SKIP_ALL" = true ]; then
                echo "Skipping skill: $skill_name (already exists)"
                continue
            fi

            if [ "$OVERWRITE_ALL" = false ]; then
                echo ""
                echo "Skill '$skill_name' already exists at $target_path"
                echo "What would you like to do?"
                echo "1) Overwrite"
                echo "2) Skip"
                echo "3) Overwrite all existing"
                echo "4) Skip all existing"
                read -p "Enter your choice (1-4): " CONFLICT_CHOICE

                case $CONFLICT_CHOICE in
                    1)
                        echo "Overwriting skill: $skill_name"
                        rm -rf "$target_path"
                        cp -r "$skill" "$target_path"
                        ;;
                    2)
                        echo "Skipping skill: $skill_name"
                        continue
                        ;;
                    3)
                        OVERWRITE_ALL=true
                        echo "Overwriting skill: $skill_name"
                        rm -rf "$target_path"
                        cp -r "$skill" "$target_path"
                        ;;
                    4)
                        SKIP_ALL=true
                        echo "Skipping skill: $skill_name"
                        continue
                        ;;
                    *)
                        echo "Invalid choice. Skipping skill: $skill_name"
                        continue
                        ;;
                esac
            else
                echo "Overwriting skill: $skill_name"
                rm -rf "$target_path"
                cp -r "$skill" "$target_path"
            fi
        else
            echo "Installing skill: $skill_name"
            cp -r "$skill" "$target_path"
        fi
    fi
done

echo ""
echo "Installation complete."