from evo.tools import file_interface
traj = file_interface.read_tum_trajectory_file("orbslam3_stereo_inertial_for_1018_00_img10hz600p_cam_traj.txt")
traj.timestamps = traj.timestamps / 1e9
file_interface.write_tum_trajectory_file("orbslam3_stereo_inertial_for_1018_00_img10hz600p_cam_traj_clean.txt", traj)