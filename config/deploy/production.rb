server 'hotelashokachomu.com', user: 'ec2-user', roles: %w{web app}
set :default_env, {
  'SECRET_KEY_BASE' => 'fc41cadc51b7b6fd75f8998f712d9e68b0e27007e635e57b33fcc03c7b35e8885a83ebc8033a4351ec1806d7b56e8598249a39132e0eecc572783725df88ca33',
  'RAILS_ENV' => 'production'
}

set :deploy_to, "/home/ec2-user/Hotel"