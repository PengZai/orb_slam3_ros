#!/usr/bin/env python3
import sys
import numpy as np
import re
from scipy.spatial.transform import Rotation as R

# Usage:
#   python3 transfer2imu.py <input_cam_traj.txt> <output_imu_traj.txt>

if len(sys.argv) != 3:
    print("Usage: python3 transfer2imu.py <input_file> <output_file>")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]

T_imu_cam = np.array(
    [
        [0.0521232345, -0.0073054379,  0.9986139389,  0.1219040939],
        [-0.9986040017, -0.0089493528,  0.0520572461,  0.0366053924],
        [0.0085566474, -0.9999332676, -0.0077617087, -0.0562970105],
        [0.0, 0.0, 0.0, 1.0]
    ]
)

with open(input_file, "r") as fin, open(output_file, "w") as fout:
    for line in fin:
        cleaned = re.sub(r"\s+", " ", line.strip())
        data = cleaned.split(" ")

        if len(data) < 8:
            continue

        ts = data[0]
        x, y, z = map(float, data[1:4])
        qx, qy, qz, qw = map(float, data[4:8])

        # Build T_w_cam
        T_w_cam = np.eye(4)
        T_w_cam[:3, :3] = R.from_quat([qx, qy, qz, qw]).as_matrix()
        T_w_cam[:3, 3] = [x, y, z]

        # Transform to IMU frame
        T_w_imu = T_imu_cam @ T_w_cam

        # Extract pose
        t_new = T_w_imu[:3, 3]
        q_new = R.from_matrix(T_w_imu[:3, :3]).as_quat()  # qx qy qz qw

        fout.write(
            f"{ts} "
            f"{t_new[0]} {t_new[1]} {t_new[2]} "
            f"{q_new[0]} {q_new[1]} {q_new[2]} {q_new[3]}\n"
        )

print(f"Conversion finished: {output_file}")