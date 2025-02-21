### How to get trajectory

when you launch orbslam program

then you could call ros service to get trajectory of left camera.

```bash
rosservice call /orb_slam3/save_traj [file_name]: save the estimated trajectory of camera and keyframes as [file_name]_cam_traj.txt and [file_name]_kf_traj.txt in ROS_HOME folder, which is /root/.ros/.
```
for example rosservice call /orb_slam3/save_traj orbslam3_stereo_inertial_with_loop_clourse_for_1005_07_img10hz600pj orbslam3_stere

then you will get the trajectory as tum format of evo


# BotanicGarden
for evaluate orbslam in BotanicGarden dataset, we need post process these .txt files first

otherwise you will get error *No matching timestamps* when using evo, please reference https://github.com/MichaelGrupp/evo/issues/12

Note that, the GT poses are tracking the VLP16 frame in BotanicGarden, so you must transform your poses to VLP16 side by extrinsic matrix before evaluation.

in here, we could use *T_rgb0_vlp16*, because orbslam output camera pose according to left camera, which is rgb0.

But through my observation, GT poses actually align on rgb0 camera frame, so we don't need to transfer





