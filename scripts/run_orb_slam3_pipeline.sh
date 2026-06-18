#!/bin/bash

# ====== USER CONFIG ======
BAG_PATH="/root/lboro_nas/PolyMap/bags/easy/easy.bag"
DATASET_DIR="/root/lboro_nas/PolyMap/bags/easy"
DEST_DIR="${DATASET_DIR}/orb_slam3_traj"

PACKAGE="orb_slam3_ros"

LAUNCH_FILES=(
    # "PolyTunnel_mono.launch"
    # "PolyTunnel_mono_inertial.launch"
    # "PolyTunnel_stereo.launch"
    "PolyTunnel_stereo_inertial.launch"
)

# transfer2imu.py is in the same directory as this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRANSFER_SCRIPT="${SCRIPT_DIR}/transfer2imu.py"

# ==========================

mkdir -p "${DEST_DIR}"

for LAUNCH in "${LAUNCH_FILES[@]}"
do
    NAME=$(basename "${LAUNCH}" .launch)

    echo "=========================================="
    echo "Running configuration: ${NAME}"
    echo "=========================================="

    # -----------------------------------
    # Output filename mapping
    # -----------------------------------
    case "$LAUNCH" in
        "PolyTunnel_mono.launch")
            OUT_NAME="orb3_m.txt"
            NEED_CONVERT=1
            ;;
        "PolyTunnel_mono_inertial.launch")
            OUT_NAME="orb3_mi.txt"
            NEED_CONVERT=0
            ;;
        "PolyTunnel_stereo.launch")
            OUT_NAME="orb3_s.txt"
            NEED_CONVERT=1
            ;;
        "PolyTunnel_stereo_inertial.launch")
            OUT_NAME="orb3_si.txt"
            NEED_CONVERT=0
            ;;
        *)
            OUT_NAME="${NAME}.txt"
            NEED_CONVERT=0
            ;;
    esac

    # Launch ORB-SLAM3
    roslaunch "${PACKAGE}" "${LAUNCH}" &
    LAUNCH_PID=$!

    sleep 8

    # Play rosbag
    rosbag play "${BAG_PATH}" --clock

    echo "Rosbag finished. Saving trajectory..."

    rosservice call /orb_slam3/save_traj "${NAME}"
    sleep 3

    SRC_FILE="/root/.ros/${NAME}_cam_traj.txt"
    DEST_FILE="${DEST_DIR}/${OUT_NAME}"

    if [ -f "$SRC_FILE" ]; then
        if [ "$NEED_CONVERT" -eq 1 ]; then
            echo "Converting ${SRC_FILE} to IMU coordinates..."
            python3 "${TRANSFER_SCRIPT}" "${SRC_FILE}" "${DEST_FILE}"

            if [ $? -eq 0 ] && [ -f "$DEST_FILE" ]; then
                echo "Converted trajectory saved to: ${DEST_FILE}"
            else
                echo "WARNING: Conversion failed for ${SRC_FILE}"
            fi
        else
            echo "No conversion needed for ${LAUNCH}. Copying trajectory..."
            cp "$SRC_FILE" "$DEST_FILE"
            echo "Trajectory saved to: ${DEST_FILE}"
        fi
    else
        echo "WARNING: Trajectory file not found: ${SRC_FILE}"
    fi

    kill -9 "$LAUNCH_PID"
    sleep 5
done

echo "All runs completed!"