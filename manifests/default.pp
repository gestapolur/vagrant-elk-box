# Update APT Cache
class { 'apt':
  always_apt_update => true,
}


# Java is required
class { 'java': }

# Elasticsearch
class { 'elasticsearch':
  manage_repo  => true,
  repo_version => '1.7',
  # version => '1.7.5'
}

elasticsearch::instance { $node_name:
  config => { 
  'cluster.name' => 'vagrant_elasticsearch',
  'index.number_of_replicas' => '0',
  'index.number_of_shards'   => '1',
  'network.host' => '0.0.0.0',
  },        # Configuration hash
  init_defaults => { } # Init defaults hash
}

elasticsearch::plugin{'royrusso/elasticsearch-HQ':
  instances  => $node_name
}

elasticsearch::plugin{'mobz/elasticsearch-head':
  instances => $node_name
}