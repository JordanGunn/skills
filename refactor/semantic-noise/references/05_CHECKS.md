# Checks

Run these checks systematically:

## 1. Prefix/Suffix Cluster Detection

Flag clusters where ≥3 symbols share a prefix or suffix within the same module/domain.

Examples:

- file_attributes, file_size, file_creation_date
- LASWriter, LAZWriter, PLYWriter
- ClassificationGround, ClassificationVegetation, ClassificationBuilding

For each cluster, propose one of:

- Extract a namespace (module/class/submodule)
- Introduce a semantic group object
- Split the file by conceptual boundary

## 2. Import Stutter and Redundant Naming

Flag imports that repeat intent already expressed by hierarchy.

Examples:

- from lidar.io.read import read_las
- from X.read import read_*
- from pulsar.api.io.driver.points.las import Las

Preferred patterns:

- from lidar.io import read; read.las(...)
- from X import read; read.las(...)
- from pulsar.api.io.driver.points import las; las.Driver.read()

## 3. Taxonomy Crammed Into Identifiers

Flag names where the distinguishing category is encoded in the identifier rather than structure.

Example smell:

- file_* functions
- config_* functions
- points_* helpers
- las_* utilities inside a las-focused module

Recommend:

- namespace extraction
- module split
- class boundary

## 4. Getter Verb Noise (Context-Aware)

Flag `get_` style methods that appear observational and add no meaning.

Examples:

- obj.get_status() vs obj.status() / obj.status
- las.get_pdrf() vs las.pdrf()

Do not flag getters that encode true semantic distinction, such as:

- get_or_create_*
- get_cached_*
- get_raw_*
- get_default_*
