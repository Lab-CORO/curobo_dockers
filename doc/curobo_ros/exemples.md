# curobo_ros Documentation

## Overview

`curobo_ros` is a ROS package designed for motion generation, inverse kinematics (IK) computation, and forward kinematics (FK) evaluation for robotic applications. This documentation details the available services provided by the package to facilitate motion generation, collision handling, and object manipulation. This projet is currently under development the documentation may be incomplete or outdated (4/02/2025).

---
## 1. Manage obstacles and objects

The motion generation and the inverse kinematics features can use obstacles and objects to avoid collisions during them execution. For both features, the objects are managed through a service interface started with the name of the feature and the name of the service. The robot spheres collisions are published on the topic `<node_name>/collision_spheres`. Currently, the robot pose is fixed at 0,0,0,0,0,0. 

| Service Name | Service Type | Description | Callback Function |
|-------------|-------------|-------------|------------------|
| `<node_name>/add_object` | [`AddObject`](https://github.com/Lab-CORO/curobo_msgs/blob/main/srv/AddObject.srv) | Adds a new object to the scene, allowing collision checking with the environment. | `callback_add_object` |
| `<node_name>/remove_object` | [`RemoveObject`](https://github.com/Lab-CORO/curobo_msgs/blob/main/srv/RemoveObject.srv) | Removes a specific object from the scene. | `callback_remove_object` |
| `<node_name>/get_obstacles` | `Trigger` | Retrieves a list of all obstacles currently present in the scene. | `callback_get_obstacles` |
| `<node_name>/remove_all_objects` | `Trigger` | Clears all objects from the scene. | `callback_remove_all_objects` |
| `<node_name>/get_voxel_grid` | [`GetVoxelGrid`](https://github.com/Lab-CORO/curobo_msgs/blob/main/srv/GetVoxelGrid.srv) | Retrieves a voxelized representation of the environment for collision checking. | `callback_get_voxel_grid` |
| `<node_name>/get_collision_distance` | [`GetCollisionDistance`](https://github.com/Lab-CORO/curobo_msgs/blob/main/srv/GetCollisionDistance.srv) | Computes the distance between objects and potential collisions in the scene. | `callback_get_collision_distance` |

| Topic Name | Message Type | Description |
|-------------|-------------|-------------|
| `<node_name>/publish_collision_spheres` | `MarkerArray` | Publishes the collision spheres used for collision avoidance. |


---

## 2. Motion Generation

The motion generation feature is provided from the node `curobo_gen_traj` an launch file is available: `launch/curobo_gen_traj.launch`. 
- To generate a trajectory, a message have to be send on the topic `marker_pose` and every 0.1s the node generate a trajectory if the `marker_pose` message is new (this part should be improve and replace by a service)
- A camera can be used to real world obstacles. 
- The trajectory is published on the topic `trajectory` and can be visualized in RViz with the package trajectory_preview. 
- Some parameters can be changed:
  - Some can be changed online 
    -  `max_attempts`
    -  `timeout`
    -  `time_dilation_factor`
  - Others have to be changed and the configuration should be update:
    - `voxel_size`
    - `collision_activation_distance`

| Service Name |Service Type | Description | Callback Function |
|-------------|-------------|-------------|------------------|
| `<node_name>/update_motion_gen_config` | `Trigger` | Updates the motion generation configuration to adjust planning parameters. | `set_motion_gen_config` |


|Topics Name |Publisher or Subscriber | Topic Type | Description | Callback Function |
|-------------|-------------|-------------|------------------|------------------|
|`marker_pose` |Subscriber | `PoseStamped` | Subscribe to the current pose of the marker. To publish a trajectory in the next 0.1s | `callback_marker_pose` |
|`/camera/camera/depth/image_rect_raw`| Subscriber | `sensor_msgs/Image` | Subscribes to the depth image from the camera. | `callback_depth_image` |
|`/camera/camera/depth/camera_info`| Subscriber | `sensor_msgs/CameraInfo` | Subscribes to the camera information. | `callback_camera_info` |
|`/trajectory`| Publisher | `trajectory_msgs/JointTrajectory` | Publishes the generated trajectory. | |

---

## 3. Batch Inverse Kinematics (IK)

These services compute inverse kinematics for multiple target poses while also utilizing object management services. The node of this feature is `curobo_ik`. As the motion generation some parameters can be change and a service is available to update the parameters.

| Service Name | Service Type | Description | Callback Function |
|-------------|-------------|-------------|------------------|
| `<node_name>/ik_batch_poses` | [`Ik`](https://github.com/Lab-CORO/curobo_msgs/blob/main/srv/Ik.srv) | Computes the inverse kinematics (IK) for multiple target poses. | `ik_callback` |

Batch IK relies on the same object management services used for motion generation, ensuring collision-aware calculations.

---

## 4. Forward Kinematics (FK) Services

Unlike motion generation and batch IK, forward kinematics does not use object management services. 

| Service Name | Service Type | Description | Callback Function |
|-------------|-------------|-------------|------------------|
| `<node_name>/fk_compute` | [`Fk`](https://github.com/Lab-CORO/curobo_msgs/blob/main/srv/Fk.srv) | Computes the forward kinematics given a set of joint positions. | `fk_callback` |

---





## Contributors
Developed and maintained by the CoRo Lab.

For issues and contributions, visit [GitHub Repository](https://github.com/Lab-CORO/curobo_ros).

