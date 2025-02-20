import os
import numpy as np 
from evo.tools import file_interface
from evo.core.trajectory import PoseTrajectory3D
import shutil

folder = "1018_00"
filename = "orbslam3_stereo_inertial_without_loop_clourse_for_1018_00_img10hz600p_kf_traj.txt"

if "cam" in filename.split("_"):
    frame_type = "cam"
else:
    frame_type = "key_frame"


filename.split(".")
filename_suffix = '.' + filename.split(".")[1]
filename = filename.split(".")[0]


# # VLP16 in RGB0 coordinates
# sensor_coordinate_transform_matrix = np.array([
#     [0.0238743541600432,-0.999707744440396,0.00360642510766516,0.138922870923538],  
#     [-0.00736968896588375,-0.00378431903190059,-0.999965147452649 ,-0.177101909101325],  
#     [0.999687515506770,0.0238486947027063,-0.00745791352160211,-0.126685267545513],  
#     [0.0,0.0,0.0,1.0]
# ])

# keep same, it seems we don't need to transfer to VLP16 coordinates, which is more precise
sensor_coordinate_transform_matrix = np.array([
    [1.,0,0,0],  
    [0,1.,0,0],  
    [0,0,1.,0],  
    [0,0,0,1.0]
])


# seems x in key frame of orbslam system is z in BotanicGarden, and y is -y
system_coordinate_transform_matrix_for_key_frame = np.array([
    [0.,  1.,  0.,   0],  
    [-1., 0.,  0.,   0],  
    [0.,  0., 1.,   0],  
    [0.,  0,   0,   1.0]
])

# seems x in camera frame of orbslam system is z in BotanicGarden, and y is -y
system_coordinate_transform_matrix_for_camera_frame = np.array([
    [1., 0,  0.,    0],  
    [0., 1., 0.,  0],  
    [0.,  0., 1.,  0],  
    [0,  0,  0,  1.0]
])




# keep same
# system_coordinate_transform_matrix = np.array([
#     [1.,0,0,0],  
#     [0,1.,0,0],  
#     [0,0,1.,0],  
#     [0,0,0,1.0]
# ])




traj = file_interface.read_tum_trajectory_file(os.path.join(folder, filename + filename_suffix))
traj.timestamps = traj.timestamps / 1e9

transformed_poses = []
for pose in traj.poses_se3:

    if frame_type == "cam":
    # Apply the transformation
        transformed_pose_matrix =   sensor_coordinate_transform_matrix @ system_coordinate_transform_matrix_for_camera_frame @ pose
    
    else: 
        transformed_pose_matrix =   sensor_coordinate_transform_matrix @ system_coordinate_transform_matrix_for_key_frame @ pose

    # Append transformed pose as SE3 object
    transformed_poses.append(transformed_pose_matrix)

traj = PoseTrajectory3D(
    poses_se3=transformed_poses,
    timestamps=traj.timestamps
)


if not os.path.exists(os.path.join(folder, filename)):
    os.makedirs(os.path.join(folder, filename))

shutil.copy(os.path.join(folder, filename + filename_suffix), os.path.join(folder, filename, filename + filename_suffix))
file_interface.write_tum_trajectory_file(os.path.join(folder, filename, filename+"_coordinate_aligned"+filename_suffix), traj)