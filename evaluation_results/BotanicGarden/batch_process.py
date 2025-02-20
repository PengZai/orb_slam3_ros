import os
import numpy as np 
from evo.tools import file_interface
from evo.core.trajectory import PoseTrajectory3D

folder = "1018_00"
filename = "orbslam3_stereo_inertial_without_loop_clourse_for_1018_00_img10hz600p_kf_traj.txt"
filename.split(".")
filename_suffix = '.' + filename.split(".")[1]
filename = filename.split(".")[0]

# # VLP16 in RGB0 coordinates
transform_matrix = np.array([
    [0.0238743541600432,-0.999707744440396,0.00360642510766516,0.138922870923538],  
    [-0.00736968896588375,-0.00378431903190059,-0.999965147452649 ,-0.177101909101325],  
    [0.999687515506770,0.0238486947027063,-0.00745791352160211,-0.126685267545513],  
    [0.0,0.0,0.0,1.0]
])

# VLP16 in Xsens coordinates
# transform_matrix = np.array([
#         [0.999678872580465,0.0252865664429322,0.00150422292234868,0.0584867781527745],
#         [-0.0252723438960774,0.999649431893338,-0.0078025434141585,0.00840419966766332],
#         [-0.00170103929405540,0.00776298237926191,0.99996789371916,0.168915521980526],
#         [0.0,0.0,0.0,1.0]
# ])

# transform_matrix = np.array([
#     [1.,0,0,0],  
#     [0,1.,0,0],  
#     [0,0,1.,0],  
#     [0,0,0,1.0]
# ])

# seems x in orbslam system is z in BotanicGarden, and y is -y
adjusted_matrix = np.array([
    [0, 0,  1.,    0],  
    [0., -1., 0.,  0],  
    [1.,  0., 0.,  0],  
    [0,  0,  0,  1.0]
])



traj = file_interface.read_tum_trajectory_file(os.path.join(folder, filename + filename_suffix))
traj.timestamps = traj.timestamps / 1e9

transformed_poses = []
for pose in traj.poses_se3:

    # Apply the transformation
    transformed_pose_matrix =   transform_matrix @ adjusted_matrix @ pose
    
    # Append transformed pose as SE3 object
    transformed_poses.append(transformed_pose_matrix)

traj = PoseTrajectory3D(
    poses_se3=transformed_poses,
    timestamps=traj.timestamps
)


file_interface.write_tum_trajectory_file(os.path.join(folder, filename+"_insecond"+filename_suffix), traj)