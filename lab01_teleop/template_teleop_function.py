# Templates:
#     ROS2 tutorial -> publisher_member_function.py
#     Ref: https://github.com/ros2/examples/tree/humble/rclpy/topics
#     ROS2 installation -> teleop_twist_keyboard.py
#     Ref: ... TODO

import rclpy
from rclpy.node import Node






class AldoTeleop(Node):
    def __init__(self):
        super().__init__('aldo_teleop')
        self.publisher_ = self.create_publisher(..., 'cmd_vel', 10)
        
        timer_period = 0.5  # seconds
        self.timer_ = self.create_timer(0.5, self.getKey_callback)
        self.get_logger().info('aldo_teleop node initialized -\m/')

    def getKey_callback(self):
        settings = termios.tcgetattr(sys.stdin) # Configuracao inicial do terminal
        tty.setraw(sys.stdin.fileno()) # Inicializar terminal para leitura de dados
        key = sys.stdin.read(1) # Leitura de um caractere dentro da string
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)

        # Selecao de movimentos
        

        self.publisher_.publish(self.twist_msg)
        self.get_logger().info('Publishing: "%s"' % self.twist_msg)


def main(args=None):
    rclpy.init(args=args)
    
    aldo_teleop = AldoTeleop()
    
    rclpy.spin(aldo_teleop)
    
    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    aldo_teleop.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()

