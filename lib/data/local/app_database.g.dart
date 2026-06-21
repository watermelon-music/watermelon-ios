// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayHistoryTable extends PlayHistory
    with TableInfo<$PlayHistoryTable, PlayHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songTitleMeta = const VerificationMeta(
    'songTitle',
  );
  @override
  late final GeneratedColumn<String> songTitle = GeneratedColumn<String>(
    'song_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songArtistMeta = const VerificationMeta(
    'songArtist',
  );
  @override
  late final GeneratedColumn<String> songArtist = GeneratedColumn<String>(
    'song_artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songCoverUrlMeta = const VerificationMeta(
    'songCoverUrl',
  );
  @override
  late final GeneratedColumn<String> songCoverUrl = GeneratedColumn<String>(
    'song_cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _playedAtMeta = const VerificationMeta(
    'playedAt',
  );
  @override
  late final GeneratedColumn<int> playedAt = GeneratedColumn<int>(
    'played_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    songId,
    songTitle,
    songArtist,
    songCoverUrl,
    audioUrl,
    source,
    playedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'play_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('song_title')) {
      context.handle(
        _songTitleMeta,
        songTitle.isAcceptableOrUnknown(data['song_title']!, _songTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_songTitleMeta);
    }
    if (data.containsKey('song_artist')) {
      context.handle(
        _songArtistMeta,
        songArtist.isAcceptableOrUnknown(data['song_artist']!, _songArtistMeta),
      );
    } else if (isInserting) {
      context.missing(_songArtistMeta);
    }
    if (data.containsKey('song_cover_url')) {
      context.handle(
        _songCoverUrlMeta,
        songCoverUrl.isAcceptableOrUnknown(
          data['song_cover_url']!,
          _songCoverUrlMeta,
        ),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('played_at')) {
      context.handle(
        _playedAtMeta,
        playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_playedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      songTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_title'],
      )!,
      songArtist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_artist'],
      )!,
      songCoverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_cover_url'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      playedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}played_at'],
      )!,
    );
  }

  @override
  $PlayHistoryTable createAlias(String alias) {
    return $PlayHistoryTable(attachedDatabase, alias);
  }
}

class PlayHistoryData extends DataClass implements Insertable<PlayHistoryData> {
  final int id;
  final String songId;
  final String songTitle;
  final String songArtist;
  final String? songCoverUrl;
  final String? audioUrl;
  final String source;
  final int playedAt;
  const PlayHistoryData({
    required this.id,
    required this.songId,
    required this.songTitle,
    required this.songArtist,
    this.songCoverUrl,
    this.audioUrl,
    required this.source,
    required this.playedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['song_id'] = Variable<String>(songId);
    map['song_title'] = Variable<String>(songTitle);
    map['song_artist'] = Variable<String>(songArtist);
    if (!nullToAbsent || songCoverUrl != null) {
      map['song_cover_url'] = Variable<String>(songCoverUrl);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['source'] = Variable<String>(source);
    map['played_at'] = Variable<int>(playedAt);
    return map;
  }

  PlayHistoryCompanion toCompanion(bool nullToAbsent) {
    return PlayHistoryCompanion(
      id: Value(id),
      songId: Value(songId),
      songTitle: Value(songTitle),
      songArtist: Value(songArtist),
      songCoverUrl: songCoverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(songCoverUrl),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      source: Value(source),
      playedAt: Value(playedAt),
    );
  }

  factory PlayHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayHistoryData(
      id: serializer.fromJson<int>(json['id']),
      songId: serializer.fromJson<String>(json['songId']),
      songTitle: serializer.fromJson<String>(json['songTitle']),
      songArtist: serializer.fromJson<String>(json['songArtist']),
      songCoverUrl: serializer.fromJson<String?>(json['songCoverUrl']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      source: serializer.fromJson<String>(json['source']),
      playedAt: serializer.fromJson<int>(json['playedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'songId': serializer.toJson<String>(songId),
      'songTitle': serializer.toJson<String>(songTitle),
      'songArtist': serializer.toJson<String>(songArtist),
      'songCoverUrl': serializer.toJson<String?>(songCoverUrl),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'source': serializer.toJson<String>(source),
      'playedAt': serializer.toJson<int>(playedAt),
    };
  }

  PlayHistoryData copyWith({
    int? id,
    String? songId,
    String? songTitle,
    String? songArtist,
    Value<String?> songCoverUrl = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    String? source,
    int? playedAt,
  }) => PlayHistoryData(
    id: id ?? this.id,
    songId: songId ?? this.songId,
    songTitle: songTitle ?? this.songTitle,
    songArtist: songArtist ?? this.songArtist,
    songCoverUrl: songCoverUrl.present ? songCoverUrl.value : this.songCoverUrl,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    source: source ?? this.source,
    playedAt: playedAt ?? this.playedAt,
  );
  PlayHistoryData copyWithCompanion(PlayHistoryCompanion data) {
    return PlayHistoryData(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      songTitle: data.songTitle.present ? data.songTitle.value : this.songTitle,
      songArtist: data.songArtist.present
          ? data.songArtist.value
          : this.songArtist,
      songCoverUrl: data.songCoverUrl.present
          ? data.songCoverUrl.value
          : this.songCoverUrl,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      source: data.source.present ? data.source.value : this.source,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayHistoryData(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('songTitle: $songTitle, ')
          ..write('songArtist: $songArtist, ')
          ..write('songCoverUrl: $songCoverUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('source: $source, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    songId,
    songTitle,
    songArtist,
    songCoverUrl,
    audioUrl,
    source,
    playedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayHistoryData &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.songTitle == this.songTitle &&
          other.songArtist == this.songArtist &&
          other.songCoverUrl == this.songCoverUrl &&
          other.audioUrl == this.audioUrl &&
          other.source == this.source &&
          other.playedAt == this.playedAt);
}

class PlayHistoryCompanion extends UpdateCompanion<PlayHistoryData> {
  final Value<int> id;
  final Value<String> songId;
  final Value<String> songTitle;
  final Value<String> songArtist;
  final Value<String?> songCoverUrl;
  final Value<String?> audioUrl;
  final Value<String> source;
  final Value<int> playedAt;
  const PlayHistoryCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.songTitle = const Value.absent(),
    this.songArtist = const Value.absent(),
    this.songCoverUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.source = const Value.absent(),
    this.playedAt = const Value.absent(),
  });
  PlayHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String songId,
    required String songTitle,
    required String songArtist,
    this.songCoverUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.source = const Value.absent(),
    required int playedAt,
  }) : songId = Value(songId),
       songTitle = Value(songTitle),
       songArtist = Value(songArtist),
       playedAt = Value(playedAt);
  static Insertable<PlayHistoryData> custom({
    Expression<int>? id,
    Expression<String>? songId,
    Expression<String>? songTitle,
    Expression<String>? songArtist,
    Expression<String>? songCoverUrl,
    Expression<String>? audioUrl,
    Expression<String>? source,
    Expression<int>? playedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (songTitle != null) 'song_title': songTitle,
      if (songArtist != null) 'song_artist': songArtist,
      if (songCoverUrl != null) 'song_cover_url': songCoverUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (source != null) 'source': source,
      if (playedAt != null) 'played_at': playedAt,
    });
  }

  PlayHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? songId,
    Value<String>? songTitle,
    Value<String>? songArtist,
    Value<String?>? songCoverUrl,
    Value<String?>? audioUrl,
    Value<String>? source,
    Value<int>? playedAt,
  }) {
    return PlayHistoryCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      songTitle: songTitle ?? this.songTitle,
      songArtist: songArtist ?? this.songArtist,
      songCoverUrl: songCoverUrl ?? this.songCoverUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      source: source ?? this.source,
      playedAt: playedAt ?? this.playedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (songTitle.present) {
      map['song_title'] = Variable<String>(songTitle.value);
    }
    if (songArtist.present) {
      map['song_artist'] = Variable<String>(songArtist.value);
    }
    if (songCoverUrl.present) {
      map['song_cover_url'] = Variable<String>(songCoverUrl.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<int>(playedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayHistoryCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('songTitle: $songTitle, ')
          ..write('songArtist: $songArtist, ')
          ..write('songCoverUrl: $songCoverUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('source: $source, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }
}

class $SkipsTable extends Skips with TableInfo<$SkipsTable, Skip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songTitleMeta = const VerificationMeta(
    'songTitle',
  );
  @override
  late final GeneratedColumn<String> songTitle = GeneratedColumn<String>(
    'song_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songArtistMeta = const VerificationMeta(
    'songArtist',
  );
  @override
  late final GeneratedColumn<String> songArtist = GeneratedColumn<String>(
    'song_artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skippedAtMeta = const VerificationMeta(
    'skippedAt',
  );
  @override
  late final GeneratedColumn<int> skippedAt = GeneratedColumn<int>(
    'skipped_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextMeta = const VerificationMeta(
    'context',
  );
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
    'context',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    songId,
    songTitle,
    songArtist,
    skippedAt,
    context,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Skip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('song_title')) {
      context.handle(
        _songTitleMeta,
        songTitle.isAcceptableOrUnknown(data['song_title']!, _songTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_songTitleMeta);
    }
    if (data.containsKey('song_artist')) {
      context.handle(
        _songArtistMeta,
        songArtist.isAcceptableOrUnknown(data['song_artist']!, _songArtistMeta),
      );
    } else if (isInserting) {
      context.missing(_songArtistMeta);
    }
    if (data.containsKey('skipped_at')) {
      context.handle(
        _skippedAtMeta,
        skippedAt.isAcceptableOrUnknown(data['skipped_at']!, _skippedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_skippedAtMeta);
    }
    if (data.containsKey('context')) {
      context.handle(
        _contextMeta,
        this.context.isAcceptableOrUnknown(data['context']!, _contextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Skip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Skip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      songTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_title'],
      )!,
      songArtist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_artist'],
      )!,
      skippedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}skipped_at'],
      )!,
      context: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context'],
      ),
    );
  }

  @override
  $SkipsTable createAlias(String alias) {
    return $SkipsTable(attachedDatabase, alias);
  }
}

class Skip extends DataClass implements Insertable<Skip> {
  final int id;
  final String songId;
  final String songTitle;
  final String songArtist;
  final int skippedAt;
  final String? context;
  const Skip({
    required this.id,
    required this.songId,
    required this.songTitle,
    required this.songArtist,
    required this.skippedAt,
    this.context,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['song_id'] = Variable<String>(songId);
    map['song_title'] = Variable<String>(songTitle);
    map['song_artist'] = Variable<String>(songArtist);
    map['skipped_at'] = Variable<int>(skippedAt);
    if (!nullToAbsent || context != null) {
      map['context'] = Variable<String>(context);
    }
    return map;
  }

  SkipsCompanion toCompanion(bool nullToAbsent) {
    return SkipsCompanion(
      id: Value(id),
      songId: Value(songId),
      songTitle: Value(songTitle),
      songArtist: Value(songArtist),
      skippedAt: Value(skippedAt),
      context: context == null && nullToAbsent
          ? const Value.absent()
          : Value(context),
    );
  }

  factory Skip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Skip(
      id: serializer.fromJson<int>(json['id']),
      songId: serializer.fromJson<String>(json['songId']),
      songTitle: serializer.fromJson<String>(json['songTitle']),
      songArtist: serializer.fromJson<String>(json['songArtist']),
      skippedAt: serializer.fromJson<int>(json['skippedAt']),
      context: serializer.fromJson<String?>(json['context']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'songId': serializer.toJson<String>(songId),
      'songTitle': serializer.toJson<String>(songTitle),
      'songArtist': serializer.toJson<String>(songArtist),
      'skippedAt': serializer.toJson<int>(skippedAt),
      'context': serializer.toJson<String?>(context),
    };
  }

  Skip copyWith({
    int? id,
    String? songId,
    String? songTitle,
    String? songArtist,
    int? skippedAt,
    Value<String?> context = const Value.absent(),
  }) => Skip(
    id: id ?? this.id,
    songId: songId ?? this.songId,
    songTitle: songTitle ?? this.songTitle,
    songArtist: songArtist ?? this.songArtist,
    skippedAt: skippedAt ?? this.skippedAt,
    context: context.present ? context.value : this.context,
  );
  Skip copyWithCompanion(SkipsCompanion data) {
    return Skip(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      songTitle: data.songTitle.present ? data.songTitle.value : this.songTitle,
      songArtist: data.songArtist.present
          ? data.songArtist.value
          : this.songArtist,
      skippedAt: data.skippedAt.present ? data.skippedAt.value : this.skippedAt,
      context: data.context.present ? data.context.value : this.context,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Skip(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('songTitle: $songTitle, ')
          ..write('songArtist: $songArtist, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('context: $context')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, songId, songTitle, songArtist, skippedAt, context);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Skip &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.songTitle == this.songTitle &&
          other.songArtist == this.songArtist &&
          other.skippedAt == this.skippedAt &&
          other.context == this.context);
}

class SkipsCompanion extends UpdateCompanion<Skip> {
  final Value<int> id;
  final Value<String> songId;
  final Value<String> songTitle;
  final Value<String> songArtist;
  final Value<int> skippedAt;
  final Value<String?> context;
  const SkipsCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.songTitle = const Value.absent(),
    this.songArtist = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.context = const Value.absent(),
  });
  SkipsCompanion.insert({
    this.id = const Value.absent(),
    required String songId,
    required String songTitle,
    required String songArtist,
    required int skippedAt,
    this.context = const Value.absent(),
  }) : songId = Value(songId),
       songTitle = Value(songTitle),
       songArtist = Value(songArtist),
       skippedAt = Value(skippedAt);
  static Insertable<Skip> custom({
    Expression<int>? id,
    Expression<String>? songId,
    Expression<String>? songTitle,
    Expression<String>? songArtist,
    Expression<int>? skippedAt,
    Expression<String>? context,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (songTitle != null) 'song_title': songTitle,
      if (songArtist != null) 'song_artist': songArtist,
      if (skippedAt != null) 'skipped_at': skippedAt,
      if (context != null) 'context': context,
    });
  }

  SkipsCompanion copyWith({
    Value<int>? id,
    Value<String>? songId,
    Value<String>? songTitle,
    Value<String>? songArtist,
    Value<int>? skippedAt,
    Value<String?>? context,
  }) {
    return SkipsCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      songTitle: songTitle ?? this.songTitle,
      songArtist: songArtist ?? this.songArtist,
      skippedAt: skippedAt ?? this.skippedAt,
      context: context ?? this.context,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (songTitle.present) {
      map['song_title'] = Variable<String>(songTitle.value);
    }
    if (songArtist.present) {
      map['song_artist'] = Variable<String>(songArtist.value);
    }
    if (skippedAt.present) {
      map['skipped_at'] = Variable<int>(skippedAt.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkipsCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('songTitle: $songTitle, ')
          ..write('songArtist: $songArtist, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('context: $context')
          ..write(')'))
        .toString();
  }
}

class $SongTransitionsTable extends SongTransitions
    with TableInfo<$SongTransitionsTable, SongTransition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongTransitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fromSongIdMeta = const VerificationMeta(
    'fromSongId',
  );
  @override
  late final GeneratedColumn<String> fromSongId = GeneratedColumn<String>(
    'from_song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toSongIdMeta = const VerificationMeta(
    'toSongId',
  );
  @override
  late final GeneratedColumn<String> toSongId = GeneratedColumn<String>(
    'to_song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastTransitionAtMeta = const VerificationMeta(
    'lastTransitionAt',
  );
  @override
  late final GeneratedColumn<int> lastTransitionAt = GeneratedColumn<int>(
    'last_transition_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    fromSongId,
    toSongId,
    count,
    lastTransitionAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'song_transitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SongTransition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('from_song_id')) {
      context.handle(
        _fromSongIdMeta,
        fromSongId.isAcceptableOrUnknown(
          data['from_song_id']!,
          _fromSongIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromSongIdMeta);
    }
    if (data.containsKey('to_song_id')) {
      context.handle(
        _toSongIdMeta,
        toSongId.isAcceptableOrUnknown(data['to_song_id']!, _toSongIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toSongIdMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('last_transition_at')) {
      context.handle(
        _lastTransitionAtMeta,
        lastTransitionAt.isAcceptableOrUnknown(
          data['last_transition_at']!,
          _lastTransitionAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastTransitionAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fromSongId, toSongId};
  @override
  SongTransition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongTransition(
      fromSongId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_song_id'],
      )!,
      toSongId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_song_id'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      lastTransitionAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_transition_at'],
      )!,
    );
  }

  @override
  $SongTransitionsTable createAlias(String alias) {
    return $SongTransitionsTable(attachedDatabase, alias);
  }
}

class SongTransition extends DataClass implements Insertable<SongTransition> {
  final String fromSongId;
  final String toSongId;
  final int count;
  final int lastTransitionAt;
  const SongTransition({
    required this.fromSongId,
    required this.toSongId,
    required this.count,
    required this.lastTransitionAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['from_song_id'] = Variable<String>(fromSongId);
    map['to_song_id'] = Variable<String>(toSongId);
    map['count'] = Variable<int>(count);
    map['last_transition_at'] = Variable<int>(lastTransitionAt);
    return map;
  }

  SongTransitionsCompanion toCompanion(bool nullToAbsent) {
    return SongTransitionsCompanion(
      fromSongId: Value(fromSongId),
      toSongId: Value(toSongId),
      count: Value(count),
      lastTransitionAt: Value(lastTransitionAt),
    );
  }

  factory SongTransition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongTransition(
      fromSongId: serializer.fromJson<String>(json['fromSongId']),
      toSongId: serializer.fromJson<String>(json['toSongId']),
      count: serializer.fromJson<int>(json['count']),
      lastTransitionAt: serializer.fromJson<int>(json['lastTransitionAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fromSongId': serializer.toJson<String>(fromSongId),
      'toSongId': serializer.toJson<String>(toSongId),
      'count': serializer.toJson<int>(count),
      'lastTransitionAt': serializer.toJson<int>(lastTransitionAt),
    };
  }

  SongTransition copyWith({
    String? fromSongId,
    String? toSongId,
    int? count,
    int? lastTransitionAt,
  }) => SongTransition(
    fromSongId: fromSongId ?? this.fromSongId,
    toSongId: toSongId ?? this.toSongId,
    count: count ?? this.count,
    lastTransitionAt: lastTransitionAt ?? this.lastTransitionAt,
  );
  SongTransition copyWithCompanion(SongTransitionsCompanion data) {
    return SongTransition(
      fromSongId: data.fromSongId.present
          ? data.fromSongId.value
          : this.fromSongId,
      toSongId: data.toSongId.present ? data.toSongId.value : this.toSongId,
      count: data.count.present ? data.count.value : this.count,
      lastTransitionAt: data.lastTransitionAt.present
          ? data.lastTransitionAt.value
          : this.lastTransitionAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongTransition(')
          ..write('fromSongId: $fromSongId, ')
          ..write('toSongId: $toSongId, ')
          ..write('count: $count, ')
          ..write('lastTransitionAt: $lastTransitionAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(fromSongId, toSongId, count, lastTransitionAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongTransition &&
          other.fromSongId == this.fromSongId &&
          other.toSongId == this.toSongId &&
          other.count == this.count &&
          other.lastTransitionAt == this.lastTransitionAt);
}

class SongTransitionsCompanion extends UpdateCompanion<SongTransition> {
  final Value<String> fromSongId;
  final Value<String> toSongId;
  final Value<int> count;
  final Value<int> lastTransitionAt;
  final Value<int> rowid;
  const SongTransitionsCompanion({
    this.fromSongId = const Value.absent(),
    this.toSongId = const Value.absent(),
    this.count = const Value.absent(),
    this.lastTransitionAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongTransitionsCompanion.insert({
    required String fromSongId,
    required String toSongId,
    this.count = const Value.absent(),
    required int lastTransitionAt,
    this.rowid = const Value.absent(),
  }) : fromSongId = Value(fromSongId),
       toSongId = Value(toSongId),
       lastTransitionAt = Value(lastTransitionAt);
  static Insertable<SongTransition> custom({
    Expression<String>? fromSongId,
    Expression<String>? toSongId,
    Expression<int>? count,
    Expression<int>? lastTransitionAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fromSongId != null) 'from_song_id': fromSongId,
      if (toSongId != null) 'to_song_id': toSongId,
      if (count != null) 'count': count,
      if (lastTransitionAt != null) 'last_transition_at': lastTransitionAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongTransitionsCompanion copyWith({
    Value<String>? fromSongId,
    Value<String>? toSongId,
    Value<int>? count,
    Value<int>? lastTransitionAt,
    Value<int>? rowid,
  }) {
    return SongTransitionsCompanion(
      fromSongId: fromSongId ?? this.fromSongId,
      toSongId: toSongId ?? this.toSongId,
      count: count ?? this.count,
      lastTransitionAt: lastTransitionAt ?? this.lastTransitionAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fromSongId.present) {
      map['from_song_id'] = Variable<String>(fromSongId.value);
    }
    if (toSongId.present) {
      map['to_song_id'] = Variable<String>(toSongId.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (lastTransitionAt.present) {
      map['last_transition_at'] = Variable<int>(lastTransitionAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongTransitionsCompanion(')
          ..write('fromSongId: $fromSongId, ')
          ..write('toSongId: $toSongId, ')
          ..write('count: $count, ')
          ..write('lastTransitionAt: $lastTransitionAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SongScoresTable extends SongScores
    with TableInfo<$SongScoresTable, SongScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [songId, score, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'song_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<SongScore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {songId};
  @override
  SongScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongScore(
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SongScoresTable createAlias(String alias) {
    return $SongScoresTable(attachedDatabase, alias);
  }
}

class SongScore extends DataClass implements Insertable<SongScore> {
  final String songId;
  final double score;
  final int updatedAt;
  const SongScore({
    required this.songId,
    required this.score,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['song_id'] = Variable<String>(songId);
    map['score'] = Variable<double>(score);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SongScoresCompanion toCompanion(bool nullToAbsent) {
    return SongScoresCompanion(
      songId: Value(songId),
      score: Value(score),
      updatedAt: Value(updatedAt),
    );
  }

  factory SongScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongScore(
      songId: serializer.fromJson<String>(json['songId']),
      score: serializer.fromJson<double>(json['score']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'songId': serializer.toJson<String>(songId),
      'score': serializer.toJson<double>(score),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SongScore copyWith({String? songId, double? score, int? updatedAt}) =>
      SongScore(
        songId: songId ?? this.songId,
        score: score ?? this.score,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SongScore copyWithCompanion(SongScoresCompanion data) {
    return SongScore(
      songId: data.songId.present ? data.songId.value : this.songId,
      score: data.score.present ? data.score.value : this.score,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongScore(')
          ..write('songId: $songId, ')
          ..write('score: $score, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(songId, score, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongScore &&
          other.songId == this.songId &&
          other.score == this.score &&
          other.updatedAt == this.updatedAt);
}

class SongScoresCompanion extends UpdateCompanion<SongScore> {
  final Value<String> songId;
  final Value<double> score;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SongScoresCompanion({
    this.songId = const Value.absent(),
    this.score = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongScoresCompanion.insert({
    required String songId,
    this.score = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : songId = Value(songId),
       updatedAt = Value(updatedAt);
  static Insertable<SongScore> custom({
    Expression<String>? songId,
    Expression<double>? score,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (songId != null) 'song_id': songId,
      if (score != null) 'score': score,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongScoresCompanion copyWith({
    Value<String>? songId,
    Value<double>? score,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SongScoresCompanion(
      songId: songId ?? this.songId,
      score: score ?? this.score,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongScoresCompanion(')
          ..write('songId: $songId, ')
          ..write('score: $score, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserActionsTable extends UserActions
    with TableInfo<$UserActionsTable, UserAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songTitleMeta = const VerificationMeta(
    'songTitle',
  );
  @override
  late final GeneratedColumn<String> songTitle = GeneratedColumn<String>(
    'song_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songArtistMeta = const VerificationMeta(
    'songArtist',
  );
  @override
  late final GeneratedColumn<String> songArtist = GeneratedColumn<String>(
    'song_artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songCoverUrlMeta = const VerificationMeta(
    'songCoverUrl',
  );
  @override
  late final GeneratedColumn<String> songCoverUrl = GeneratedColumn<String>(
    'song_cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _albumNameMeta = const VerificationMeta(
    'albumName',
  );
  @override
  late final GeneratedColumn<String> albumName = GeneratedColumn<String>(
    'album_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedToServerMeta = const VerificationMeta(
    'syncedToServer',
  );
  @override
  late final GeneratedColumn<bool> syncedToServer = GeneratedColumn<bool>(
    'synced_to_server',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced_to_server" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    songId,
    actionType,
    songTitle,
    songArtist,
    songCoverUrl,
    audioUrl,
    durationMs,
    albumName,
    genre,
    createdAt,
    syncedToServer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('song_title')) {
      context.handle(
        _songTitleMeta,
        songTitle.isAcceptableOrUnknown(data['song_title']!, _songTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_songTitleMeta);
    }
    if (data.containsKey('song_artist')) {
      context.handle(
        _songArtistMeta,
        songArtist.isAcceptableOrUnknown(data['song_artist']!, _songArtistMeta),
      );
    } else if (isInserting) {
      context.missing(_songArtistMeta);
    }
    if (data.containsKey('song_cover_url')) {
      context.handle(
        _songCoverUrlMeta,
        songCoverUrl.isAcceptableOrUnknown(
          data['song_cover_url']!,
          _songCoverUrlMeta,
        ),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('album_name')) {
      context.handle(
        _albumNameMeta,
        albumName.isAcceptableOrUnknown(data['album_name']!, _albumNameMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_to_server')) {
      context.handle(
        _syncedToServerMeta,
        syncedToServer.isAcceptableOrUnknown(
          data['synced_to_server']!,
          _syncedToServerMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {songId, actionType},
  ];
  @override
  UserAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserAction(
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      songTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_title'],
      )!,
      songArtist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_artist'],
      )!,
      songCoverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_cover_url'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      albumName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_name'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      syncedToServer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced_to_server'],
      )!,
    );
  }

  @override
  $UserActionsTable createAlias(String alias) {
    return $UserActionsTable(attachedDatabase, alias);
  }
}

class UserAction extends DataClass implements Insertable<UserAction> {
  final String songId;

  /// 'favorite' or 'recent'.
  final String actionType;
  final String songTitle;
  final String songArtist;
  final String? songCoverUrl;
  final String? audioUrl;
  final int durationMs;
  final String? albumName;
  final String? genre;
  final int createdAt;
  final bool syncedToServer;
  const UserAction({
    required this.songId,
    required this.actionType,
    required this.songTitle,
    required this.songArtist,
    this.songCoverUrl,
    this.audioUrl,
    required this.durationMs,
    this.albumName,
    this.genre,
    required this.createdAt,
    required this.syncedToServer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['song_id'] = Variable<String>(songId);
    map['action_type'] = Variable<String>(actionType);
    map['song_title'] = Variable<String>(songTitle);
    map['song_artist'] = Variable<String>(songArtist);
    if (!nullToAbsent || songCoverUrl != null) {
      map['song_cover_url'] = Variable<String>(songCoverUrl);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['duration_ms'] = Variable<int>(durationMs);
    if (!nullToAbsent || albumName != null) {
      map['album_name'] = Variable<String>(albumName);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['synced_to_server'] = Variable<bool>(syncedToServer);
    return map;
  }

  UserActionsCompanion toCompanion(bool nullToAbsent) {
    return UserActionsCompanion(
      songId: Value(songId),
      actionType: Value(actionType),
      songTitle: Value(songTitle),
      songArtist: Value(songArtist),
      songCoverUrl: songCoverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(songCoverUrl),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      durationMs: Value(durationMs),
      albumName: albumName == null && nullToAbsent
          ? const Value.absent()
          : Value(albumName),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      createdAt: Value(createdAt),
      syncedToServer: Value(syncedToServer),
    );
  }

  factory UserAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserAction(
      songId: serializer.fromJson<String>(json['songId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      songTitle: serializer.fromJson<String>(json['songTitle']),
      songArtist: serializer.fromJson<String>(json['songArtist']),
      songCoverUrl: serializer.fromJson<String?>(json['songCoverUrl']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      albumName: serializer.fromJson<String?>(json['albumName']),
      genre: serializer.fromJson<String?>(json['genre']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      syncedToServer: serializer.fromJson<bool>(json['syncedToServer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'songId': serializer.toJson<String>(songId),
      'actionType': serializer.toJson<String>(actionType),
      'songTitle': serializer.toJson<String>(songTitle),
      'songArtist': serializer.toJson<String>(songArtist),
      'songCoverUrl': serializer.toJson<String?>(songCoverUrl),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'durationMs': serializer.toJson<int>(durationMs),
      'albumName': serializer.toJson<String?>(albumName),
      'genre': serializer.toJson<String?>(genre),
      'createdAt': serializer.toJson<int>(createdAt),
      'syncedToServer': serializer.toJson<bool>(syncedToServer),
    };
  }

  UserAction copyWith({
    String? songId,
    String? actionType,
    String? songTitle,
    String? songArtist,
    Value<String?> songCoverUrl = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    int? durationMs,
    Value<String?> albumName = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    int? createdAt,
    bool? syncedToServer,
  }) => UserAction(
    songId: songId ?? this.songId,
    actionType: actionType ?? this.actionType,
    songTitle: songTitle ?? this.songTitle,
    songArtist: songArtist ?? this.songArtist,
    songCoverUrl: songCoverUrl.present ? songCoverUrl.value : this.songCoverUrl,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    durationMs: durationMs ?? this.durationMs,
    albumName: albumName.present ? albumName.value : this.albumName,
    genre: genre.present ? genre.value : this.genre,
    createdAt: createdAt ?? this.createdAt,
    syncedToServer: syncedToServer ?? this.syncedToServer,
  );
  UserAction copyWithCompanion(UserActionsCompanion data) {
    return UserAction(
      songId: data.songId.present ? data.songId.value : this.songId,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      songTitle: data.songTitle.present ? data.songTitle.value : this.songTitle,
      songArtist: data.songArtist.present
          ? data.songArtist.value
          : this.songArtist,
      songCoverUrl: data.songCoverUrl.present
          ? data.songCoverUrl.value
          : this.songCoverUrl,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      albumName: data.albumName.present ? data.albumName.value : this.albumName,
      genre: data.genre.present ? data.genre.value : this.genre,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedToServer: data.syncedToServer.present
          ? data.syncedToServer.value
          : this.syncedToServer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserAction(')
          ..write('songId: $songId, ')
          ..write('actionType: $actionType, ')
          ..write('songTitle: $songTitle, ')
          ..write('songArtist: $songArtist, ')
          ..write('songCoverUrl: $songCoverUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('durationMs: $durationMs, ')
          ..write('albumName: $albumName, ')
          ..write('genre: $genre, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedToServer: $syncedToServer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    songId,
    actionType,
    songTitle,
    songArtist,
    songCoverUrl,
    audioUrl,
    durationMs,
    albumName,
    genre,
    createdAt,
    syncedToServer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserAction &&
          other.songId == this.songId &&
          other.actionType == this.actionType &&
          other.songTitle == this.songTitle &&
          other.songArtist == this.songArtist &&
          other.songCoverUrl == this.songCoverUrl &&
          other.audioUrl == this.audioUrl &&
          other.durationMs == this.durationMs &&
          other.albumName == this.albumName &&
          other.genre == this.genre &&
          other.createdAt == this.createdAt &&
          other.syncedToServer == this.syncedToServer);
}

class UserActionsCompanion extends UpdateCompanion<UserAction> {
  final Value<String> songId;
  final Value<String> actionType;
  final Value<String> songTitle;
  final Value<String> songArtist;
  final Value<String?> songCoverUrl;
  final Value<String?> audioUrl;
  final Value<int> durationMs;
  final Value<String?> albumName;
  final Value<String?> genre;
  final Value<int> createdAt;
  final Value<bool> syncedToServer;
  final Value<int> rowid;
  const UserActionsCompanion({
    this.songId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.songTitle = const Value.absent(),
    this.songArtist = const Value.absent(),
    this.songCoverUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.albumName = const Value.absent(),
    this.genre = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedToServer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserActionsCompanion.insert({
    required String songId,
    required String actionType,
    required String songTitle,
    required String songArtist,
    this.songCoverUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.albumName = const Value.absent(),
    this.genre = const Value.absent(),
    required int createdAt,
    this.syncedToServer = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : songId = Value(songId),
       actionType = Value(actionType),
       songTitle = Value(songTitle),
       songArtist = Value(songArtist),
       createdAt = Value(createdAt);
  static Insertable<UserAction> custom({
    Expression<String>? songId,
    Expression<String>? actionType,
    Expression<String>? songTitle,
    Expression<String>? songArtist,
    Expression<String>? songCoverUrl,
    Expression<String>? audioUrl,
    Expression<int>? durationMs,
    Expression<String>? albumName,
    Expression<String>? genre,
    Expression<int>? createdAt,
    Expression<bool>? syncedToServer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (songId != null) 'song_id': songId,
      if (actionType != null) 'action_type': actionType,
      if (songTitle != null) 'song_title': songTitle,
      if (songArtist != null) 'song_artist': songArtist,
      if (songCoverUrl != null) 'song_cover_url': songCoverUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (durationMs != null) 'duration_ms': durationMs,
      if (albumName != null) 'album_name': albumName,
      if (genre != null) 'genre': genre,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedToServer != null) 'synced_to_server': syncedToServer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserActionsCompanion copyWith({
    Value<String>? songId,
    Value<String>? actionType,
    Value<String>? songTitle,
    Value<String>? songArtist,
    Value<String?>? songCoverUrl,
    Value<String?>? audioUrl,
    Value<int>? durationMs,
    Value<String?>? albumName,
    Value<String?>? genre,
    Value<int>? createdAt,
    Value<bool>? syncedToServer,
    Value<int>? rowid,
  }) {
    return UserActionsCompanion(
      songId: songId ?? this.songId,
      actionType: actionType ?? this.actionType,
      songTitle: songTitle ?? this.songTitle,
      songArtist: songArtist ?? this.songArtist,
      songCoverUrl: songCoverUrl ?? this.songCoverUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      durationMs: durationMs ?? this.durationMs,
      albumName: albumName ?? this.albumName,
      genre: genre ?? this.genre,
      createdAt: createdAt ?? this.createdAt,
      syncedToServer: syncedToServer ?? this.syncedToServer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (songTitle.present) {
      map['song_title'] = Variable<String>(songTitle.value);
    }
    if (songArtist.present) {
      map['song_artist'] = Variable<String>(songArtist.value);
    }
    if (songCoverUrl.present) {
      map['song_cover_url'] = Variable<String>(songCoverUrl.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (albumName.present) {
      map['album_name'] = Variable<String>(albumName.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (syncedToServer.present) {
      map['synced_to_server'] = Variable<bool>(syncedToServer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserActionsCompanion(')
          ..write('songId: $songId, ')
          ..write('actionType: $actionType, ')
          ..write('songTitle: $songTitle, ')
          ..write('songArtist: $songArtist, ')
          ..write('songCoverUrl: $songCoverUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('durationMs: $durationMs, ')
          ..write('albumName: $albumName, ')
          ..write('genre: $genre, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedToServer: $syncedToServer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadioStationsTable extends RadioStations
    with TableInfo<$RadioStationsTable, RadioStation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadioStationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stationUuidMeta = const VerificationMeta(
    'stationUuid',
  );
  @override
  late final GeneratedColumn<String> stationUuid = GeneratedColumn<String>(
    'station_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlResolvedMeta = const VerificationMeta(
    'urlResolved',
  );
  @override
  late final GeneratedColumn<String> urlResolved = GeneratedColumn<String>(
    'url_resolved',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _faviconMeta = const VerificationMeta(
    'favicon',
  );
  @override
  late final GeneratedColumn<String> favicon = GeneratedColumn<String>(
    'favicon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countrycodeMeta = const VerificationMeta(
    'countrycode',
  );
  @override
  late final GeneratedColumn<String> countrycode = GeneratedColumn<String>(
    'countrycode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bitrateMeta = const VerificationMeta(
    'bitrate',
  );
  @override
  late final GeneratedColumn<int> bitrate = GeneratedColumn<int>(
    'bitrate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _votesMeta = const VerificationMeta('votes');
  @override
  late final GeneratedColumn<int> votes = GeneratedColumn<int>(
    'votes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedToServerMeta = const VerificationMeta(
    'syncedToServer',
  );
  @override
  late final GeneratedColumn<bool> syncedToServer = GeneratedColumn<bool>(
    'synced_to_server',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced_to_server" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    stationUuid,
    actionType,
    name,
    url,
    urlResolved,
    favicon,
    country,
    countrycode,
    language,
    tags,
    bitrate,
    votes,
    createdAt,
    syncedToServer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radio_stations';
  @override
  VerificationContext validateIntegrity(
    Insertable<RadioStation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('station_uuid')) {
      context.handle(
        _stationUuidMeta,
        stationUuid.isAcceptableOrUnknown(
          data['station_uuid']!,
          _stationUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stationUuidMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('url_resolved')) {
      context.handle(
        _urlResolvedMeta,
        urlResolved.isAcceptableOrUnknown(
          data['url_resolved']!,
          _urlResolvedMeta,
        ),
      );
    }
    if (data.containsKey('favicon')) {
      context.handle(
        _faviconMeta,
        favicon.isAcceptableOrUnknown(data['favicon']!, _faviconMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('countrycode')) {
      context.handle(
        _countrycodeMeta,
        countrycode.isAcceptableOrUnknown(
          data['countrycode']!,
          _countrycodeMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('bitrate')) {
      context.handle(
        _bitrateMeta,
        bitrate.isAcceptableOrUnknown(data['bitrate']!, _bitrateMeta),
      );
    }
    if (data.containsKey('votes')) {
      context.handle(
        _votesMeta,
        votes.isAcceptableOrUnknown(data['votes']!, _votesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_to_server')) {
      context.handle(
        _syncedToServerMeta,
        syncedToServer.isAcceptableOrUnknown(
          data['synced_to_server']!,
          _syncedToServerMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {stationUuid, actionType},
  ];
  @override
  RadioStation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadioStation(
      stationUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_uuid'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      urlResolved: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url_resolved'],
      ),
      favicon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favicon'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      countrycode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}countrycode'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      bitrate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bitrate'],
      )!,
      votes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}votes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      syncedToServer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced_to_server'],
      )!,
    );
  }

  @override
  $RadioStationsTable createAlias(String alias) {
    return $RadioStationsTable(attachedDatabase, alias);
  }
}

class RadioStation extends DataClass implements Insertable<RadioStation> {
  final String stationUuid;

  /// 'favorite' or 'recent'.
  final String actionType;
  final String? name;
  final String? url;
  final String? urlResolved;
  final String? favicon;
  final String? country;
  final String? countrycode;
  final String? language;
  final String? tags;
  final int bitrate;
  final int votes;
  final int createdAt;
  final bool syncedToServer;
  const RadioStation({
    required this.stationUuid,
    required this.actionType,
    this.name,
    this.url,
    this.urlResolved,
    this.favicon,
    this.country,
    this.countrycode,
    this.language,
    this.tags,
    required this.bitrate,
    required this.votes,
    required this.createdAt,
    required this.syncedToServer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['station_uuid'] = Variable<String>(stationUuid);
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || urlResolved != null) {
      map['url_resolved'] = Variable<String>(urlResolved);
    }
    if (!nullToAbsent || favicon != null) {
      map['favicon'] = Variable<String>(favicon);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || countrycode != null) {
      map['countrycode'] = Variable<String>(countrycode);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['bitrate'] = Variable<int>(bitrate);
    map['votes'] = Variable<int>(votes);
    map['created_at'] = Variable<int>(createdAt);
    map['synced_to_server'] = Variable<bool>(syncedToServer);
    return map;
  }

  RadioStationsCompanion toCompanion(bool nullToAbsent) {
    return RadioStationsCompanion(
      stationUuid: Value(stationUuid),
      actionType: Value(actionType),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      urlResolved: urlResolved == null && nullToAbsent
          ? const Value.absent()
          : Value(urlResolved),
      favicon: favicon == null && nullToAbsent
          ? const Value.absent()
          : Value(favicon),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      countrycode: countrycode == null && nullToAbsent
          ? const Value.absent()
          : Value(countrycode),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      bitrate: Value(bitrate),
      votes: Value(votes),
      createdAt: Value(createdAt),
      syncedToServer: Value(syncedToServer),
    );
  }

  factory RadioStation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadioStation(
      stationUuid: serializer.fromJson<String>(json['stationUuid']),
      actionType: serializer.fromJson<String>(json['actionType']),
      name: serializer.fromJson<String?>(json['name']),
      url: serializer.fromJson<String?>(json['url']),
      urlResolved: serializer.fromJson<String?>(json['urlResolved']),
      favicon: serializer.fromJson<String?>(json['favicon']),
      country: serializer.fromJson<String?>(json['country']),
      countrycode: serializer.fromJson<String?>(json['countrycode']),
      language: serializer.fromJson<String?>(json['language']),
      tags: serializer.fromJson<String?>(json['tags']),
      bitrate: serializer.fromJson<int>(json['bitrate']),
      votes: serializer.fromJson<int>(json['votes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      syncedToServer: serializer.fromJson<bool>(json['syncedToServer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stationUuid': serializer.toJson<String>(stationUuid),
      'actionType': serializer.toJson<String>(actionType),
      'name': serializer.toJson<String?>(name),
      'url': serializer.toJson<String?>(url),
      'urlResolved': serializer.toJson<String?>(urlResolved),
      'favicon': serializer.toJson<String?>(favicon),
      'country': serializer.toJson<String?>(country),
      'countrycode': serializer.toJson<String?>(countrycode),
      'language': serializer.toJson<String?>(language),
      'tags': serializer.toJson<String?>(tags),
      'bitrate': serializer.toJson<int>(bitrate),
      'votes': serializer.toJson<int>(votes),
      'createdAt': serializer.toJson<int>(createdAt),
      'syncedToServer': serializer.toJson<bool>(syncedToServer),
    };
  }

  RadioStation copyWith({
    String? stationUuid,
    String? actionType,
    Value<String?> name = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> urlResolved = const Value.absent(),
    Value<String?> favicon = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> countrycode = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    int? bitrate,
    int? votes,
    int? createdAt,
    bool? syncedToServer,
  }) => RadioStation(
    stationUuid: stationUuid ?? this.stationUuid,
    actionType: actionType ?? this.actionType,
    name: name.present ? name.value : this.name,
    url: url.present ? url.value : this.url,
    urlResolved: urlResolved.present ? urlResolved.value : this.urlResolved,
    favicon: favicon.present ? favicon.value : this.favicon,
    country: country.present ? country.value : this.country,
    countrycode: countrycode.present ? countrycode.value : this.countrycode,
    language: language.present ? language.value : this.language,
    tags: tags.present ? tags.value : this.tags,
    bitrate: bitrate ?? this.bitrate,
    votes: votes ?? this.votes,
    createdAt: createdAt ?? this.createdAt,
    syncedToServer: syncedToServer ?? this.syncedToServer,
  );
  RadioStation copyWithCompanion(RadioStationsCompanion data) {
    return RadioStation(
      stationUuid: data.stationUuid.present
          ? data.stationUuid.value
          : this.stationUuid,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      urlResolved: data.urlResolved.present
          ? data.urlResolved.value
          : this.urlResolved,
      favicon: data.favicon.present ? data.favicon.value : this.favicon,
      country: data.country.present ? data.country.value : this.country,
      countrycode: data.countrycode.present
          ? data.countrycode.value
          : this.countrycode,
      language: data.language.present ? data.language.value : this.language,
      tags: data.tags.present ? data.tags.value : this.tags,
      bitrate: data.bitrate.present ? data.bitrate.value : this.bitrate,
      votes: data.votes.present ? data.votes.value : this.votes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedToServer: data.syncedToServer.present
          ? data.syncedToServer.value
          : this.syncedToServer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadioStation(')
          ..write('stationUuid: $stationUuid, ')
          ..write('actionType: $actionType, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('urlResolved: $urlResolved, ')
          ..write('favicon: $favicon, ')
          ..write('country: $country, ')
          ..write('countrycode: $countrycode, ')
          ..write('language: $language, ')
          ..write('tags: $tags, ')
          ..write('bitrate: $bitrate, ')
          ..write('votes: $votes, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedToServer: $syncedToServer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    stationUuid,
    actionType,
    name,
    url,
    urlResolved,
    favicon,
    country,
    countrycode,
    language,
    tags,
    bitrate,
    votes,
    createdAt,
    syncedToServer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadioStation &&
          other.stationUuid == this.stationUuid &&
          other.actionType == this.actionType &&
          other.name == this.name &&
          other.url == this.url &&
          other.urlResolved == this.urlResolved &&
          other.favicon == this.favicon &&
          other.country == this.country &&
          other.countrycode == this.countrycode &&
          other.language == this.language &&
          other.tags == this.tags &&
          other.bitrate == this.bitrate &&
          other.votes == this.votes &&
          other.createdAt == this.createdAt &&
          other.syncedToServer == this.syncedToServer);
}

class RadioStationsCompanion extends UpdateCompanion<RadioStation> {
  final Value<String> stationUuid;
  final Value<String> actionType;
  final Value<String?> name;
  final Value<String?> url;
  final Value<String?> urlResolved;
  final Value<String?> favicon;
  final Value<String?> country;
  final Value<String?> countrycode;
  final Value<String?> language;
  final Value<String?> tags;
  final Value<int> bitrate;
  final Value<int> votes;
  final Value<int> createdAt;
  final Value<bool> syncedToServer;
  final Value<int> rowid;
  const RadioStationsCompanion({
    this.stationUuid = const Value.absent(),
    this.actionType = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.urlResolved = const Value.absent(),
    this.favicon = const Value.absent(),
    this.country = const Value.absent(),
    this.countrycode = const Value.absent(),
    this.language = const Value.absent(),
    this.tags = const Value.absent(),
    this.bitrate = const Value.absent(),
    this.votes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedToServer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RadioStationsCompanion.insert({
    required String stationUuid,
    required String actionType,
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.urlResolved = const Value.absent(),
    this.favicon = const Value.absent(),
    this.country = const Value.absent(),
    this.countrycode = const Value.absent(),
    this.language = const Value.absent(),
    this.tags = const Value.absent(),
    this.bitrate = const Value.absent(),
    this.votes = const Value.absent(),
    required int createdAt,
    this.syncedToServer = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : stationUuid = Value(stationUuid),
       actionType = Value(actionType),
       createdAt = Value(createdAt);
  static Insertable<RadioStation> custom({
    Expression<String>? stationUuid,
    Expression<String>? actionType,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? urlResolved,
    Expression<String>? favicon,
    Expression<String>? country,
    Expression<String>? countrycode,
    Expression<String>? language,
    Expression<String>? tags,
    Expression<int>? bitrate,
    Expression<int>? votes,
    Expression<int>? createdAt,
    Expression<bool>? syncedToServer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stationUuid != null) 'station_uuid': stationUuid,
      if (actionType != null) 'action_type': actionType,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (urlResolved != null) 'url_resolved': urlResolved,
      if (favicon != null) 'favicon': favicon,
      if (country != null) 'country': country,
      if (countrycode != null) 'countrycode': countrycode,
      if (language != null) 'language': language,
      if (tags != null) 'tags': tags,
      if (bitrate != null) 'bitrate': bitrate,
      if (votes != null) 'votes': votes,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedToServer != null) 'synced_to_server': syncedToServer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RadioStationsCompanion copyWith({
    Value<String>? stationUuid,
    Value<String>? actionType,
    Value<String?>? name,
    Value<String?>? url,
    Value<String?>? urlResolved,
    Value<String?>? favicon,
    Value<String?>? country,
    Value<String?>? countrycode,
    Value<String?>? language,
    Value<String?>? tags,
    Value<int>? bitrate,
    Value<int>? votes,
    Value<int>? createdAt,
    Value<bool>? syncedToServer,
    Value<int>? rowid,
  }) {
    return RadioStationsCompanion(
      stationUuid: stationUuid ?? this.stationUuid,
      actionType: actionType ?? this.actionType,
      name: name ?? this.name,
      url: url ?? this.url,
      urlResolved: urlResolved ?? this.urlResolved,
      favicon: favicon ?? this.favicon,
      country: country ?? this.country,
      countrycode: countrycode ?? this.countrycode,
      language: language ?? this.language,
      tags: tags ?? this.tags,
      bitrate: bitrate ?? this.bitrate,
      votes: votes ?? this.votes,
      createdAt: createdAt ?? this.createdAt,
      syncedToServer: syncedToServer ?? this.syncedToServer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stationUuid.present) {
      map['station_uuid'] = Variable<String>(stationUuid.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (urlResolved.present) {
      map['url_resolved'] = Variable<String>(urlResolved.value);
    }
    if (favicon.present) {
      map['favicon'] = Variable<String>(favicon.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (countrycode.present) {
      map['countrycode'] = Variable<String>(countrycode.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (bitrate.present) {
      map['bitrate'] = Variable<int>(bitrate.value);
    }
    if (votes.present) {
      map['votes'] = Variable<int>(votes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (syncedToServer.present) {
      map['synced_to_server'] = Variable<bool>(syncedToServer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadioStationsCompanion(')
          ..write('stationUuid: $stationUuid, ')
          ..write('actionType: $actionType, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('urlResolved: $urlResolved, ')
          ..write('favicon: $favicon, ')
          ..write('country: $country, ')
          ..write('countrycode: $countrycode, ')
          ..write('language: $language, ')
          ..write('tags: $tags, ')
          ..write('bitrate: $bitrate, ')
          ..write('votes: $votes, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedToServer: $syncedToServer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadedSongsTable extends DownloadedSongs
    with TableInfo<$DownloadedSongsTable, DownloadedSong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedSongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    songId,
    title,
    artist,
    coverUrl,
    localFilePath,
    fileSize,
    downloadedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_songs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadedSong> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localFilePathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {songId};
  @override
  DownloadedSong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedSong(
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      )!,
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_at'],
      )!,
    );
  }

  @override
  $DownloadedSongsTable createAlias(String alias) {
    return $DownloadedSongsTable(attachedDatabase, alias);
  }
}

class DownloadedSong extends DataClass implements Insertable<DownloadedSong> {
  final String songId;
  final String title;
  final String artist;
  final String? coverUrl;
  final String localFilePath;
  final int fileSize;
  final int downloadedAt;
  const DownloadedSong({
    required this.songId,
    required this.title,
    required this.artist,
    this.coverUrl,
    required this.localFilePath,
    required this.fileSize,
    required this.downloadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['song_id'] = Variable<String>(songId);
    map['title'] = Variable<String>(title);
    map['artist'] = Variable<String>(artist);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    map['local_file_path'] = Variable<String>(localFilePath);
    map['file_size'] = Variable<int>(fileSize);
    map['downloaded_at'] = Variable<int>(downloadedAt);
    return map;
  }

  DownloadedSongsCompanion toCompanion(bool nullToAbsent) {
    return DownloadedSongsCompanion(
      songId: Value(songId),
      title: Value(title),
      artist: Value(artist),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      localFilePath: Value(localFilePath),
      fileSize: Value(fileSize),
      downloadedAt: Value(downloadedAt),
    );
  }

  factory DownloadedSong.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedSong(
      songId: serializer.fromJson<String>(json['songId']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      localFilePath: serializer.fromJson<String>(json['localFilePath']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'songId': serializer.toJson<String>(songId),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'localFilePath': serializer.toJson<String>(localFilePath),
      'fileSize': serializer.toJson<int>(fileSize),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
    };
  }

  DownloadedSong copyWith({
    String? songId,
    String? title,
    String? artist,
    Value<String?> coverUrl = const Value.absent(),
    String? localFilePath,
    int? fileSize,
    int? downloadedAt,
  }) => DownloadedSong(
    songId: songId ?? this.songId,
    title: title ?? this.title,
    artist: artist ?? this.artist,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    localFilePath: localFilePath ?? this.localFilePath,
    fileSize: fileSize ?? this.fileSize,
    downloadedAt: downloadedAt ?? this.downloadedAt,
  );
  DownloadedSong copyWithCompanion(DownloadedSongsCompanion data) {
    return DownloadedSong(
      songId: data.songId.present ? data.songId.value : this.songId,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedSong(')
          ..write('songId: $songId, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    songId,
    title,
    artist,
    coverUrl,
    localFilePath,
    fileSize,
    downloadedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedSong &&
          other.songId == this.songId &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.coverUrl == this.coverUrl &&
          other.localFilePath == this.localFilePath &&
          other.fileSize == this.fileSize &&
          other.downloadedAt == this.downloadedAt);
}

class DownloadedSongsCompanion extends UpdateCompanion<DownloadedSong> {
  final Value<String> songId;
  final Value<String> title;
  final Value<String> artist;
  final Value<String?> coverUrl;
  final Value<String> localFilePath;
  final Value<int> fileSize;
  final Value<int> downloadedAt;
  final Value<int> rowid;
  const DownloadedSongsCompanion({
    this.songId = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadedSongsCompanion.insert({
    required String songId,
    required String title,
    required String artist,
    this.coverUrl = const Value.absent(),
    required String localFilePath,
    this.fileSize = const Value.absent(),
    required int downloadedAt,
    this.rowid = const Value.absent(),
  }) : songId = Value(songId),
       title = Value(title),
       artist = Value(artist),
       localFilePath = Value(localFilePath),
       downloadedAt = Value(downloadedAt);
  static Insertable<DownloadedSong> custom({
    Expression<String>? songId,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? coverUrl,
    Expression<String>? localFilePath,
    Expression<int>? fileSize,
    Expression<int>? downloadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (songId != null) 'song_id': songId,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (fileSize != null) 'file_size': fileSize,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadedSongsCompanion copyWith({
    Value<String>? songId,
    Value<String>? title,
    Value<String>? artist,
    Value<String?>? coverUrl,
    Value<String>? localFilePath,
    Value<int>? fileSize,
    Value<int>? downloadedAt,
    Value<int>? rowid,
  }) {
    return DownloadedSongsCompanion(
      songId: songId ?? this.songId,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      coverUrl: coverUrl ?? this.coverUrl,
      localFilePath: localFilePath ?? this.localFilePath,
      fileSize: fileSize ?? this.fileSize,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedSongsCompanion(')
          ..write('songId: $songId, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSongsTable extends CachedSongs
    with TableInfo<$CachedSongsTable, CachedSong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<int> cachedAt = GeneratedColumn<int>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    songId,
    query,
    title,
    artist,
    coverUrl,
    audioUrl,
    durationMs,
    genre,
    position,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_songs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSong> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('query')) {
      context.handle(
        _queryMeta,
        query.isAcceptableOrUnknown(data['query']!, _queryMeta),
      );
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {songId, query};
  @override
  CachedSong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSong(
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      query: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      )!,
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedSongsTable createAlias(String alias) {
    return $CachedSongsTable(attachedDatabase, alias);
  }
}

class CachedSong extends DataClass implements Insertable<CachedSong> {
  final String songId;

  /// Lowercased search query, or 'trending'.
  final String query;
  final String title;
  final String artist;
  final String? coverUrl;
  final String? audioUrl;
  final int durationMs;
  final String? genre;
  final int position;
  final int cachedAt;
  const CachedSong({
    required this.songId,
    required this.query,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.audioUrl,
    required this.durationMs,
    this.genre,
    required this.position,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['song_id'] = Variable<String>(songId);
    map['query'] = Variable<String>(query);
    map['title'] = Variable<String>(title);
    map['artist'] = Variable<String>(artist);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['duration_ms'] = Variable<int>(durationMs);
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    map['position'] = Variable<int>(position);
    map['cached_at'] = Variable<int>(cachedAt);
    return map;
  }

  CachedSongsCompanion toCompanion(bool nullToAbsent) {
    return CachedSongsCompanion(
      songId: Value(songId),
      query: Value(query),
      title: Value(title),
      artist: Value(artist),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      durationMs: Value(durationMs),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      position: Value(position),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedSong.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSong(
      songId: serializer.fromJson<String>(json['songId']),
      query: serializer.fromJson<String>(json['query']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      genre: serializer.fromJson<String?>(json['genre']),
      position: serializer.fromJson<int>(json['position']),
      cachedAt: serializer.fromJson<int>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'songId': serializer.toJson<String>(songId),
      'query': serializer.toJson<String>(query),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'durationMs': serializer.toJson<int>(durationMs),
      'genre': serializer.toJson<String?>(genre),
      'position': serializer.toJson<int>(position),
      'cachedAt': serializer.toJson<int>(cachedAt),
    };
  }

  CachedSong copyWith({
    String? songId,
    String? query,
    String? title,
    String? artist,
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    int? durationMs,
    Value<String?> genre = const Value.absent(),
    int? position,
    int? cachedAt,
  }) => CachedSong(
    songId: songId ?? this.songId,
    query: query ?? this.query,
    title: title ?? this.title,
    artist: artist ?? this.artist,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    durationMs: durationMs ?? this.durationMs,
    genre: genre.present ? genre.value : this.genre,
    position: position ?? this.position,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedSong copyWithCompanion(CachedSongsCompanion data) {
    return CachedSong(
      songId: data.songId.present ? data.songId.value : this.songId,
      query: data.query.present ? data.query.value : this.query,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      genre: data.genre.present ? data.genre.value : this.genre,
      position: data.position.present ? data.position.value : this.position,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSong(')
          ..write('songId: $songId, ')
          ..write('query: $query, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('durationMs: $durationMs, ')
          ..write('genre: $genre, ')
          ..write('position: $position, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    songId,
    query,
    title,
    artist,
    coverUrl,
    audioUrl,
    durationMs,
    genre,
    position,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSong &&
          other.songId == this.songId &&
          other.query == this.query &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.coverUrl == this.coverUrl &&
          other.audioUrl == this.audioUrl &&
          other.durationMs == this.durationMs &&
          other.genre == this.genre &&
          other.position == this.position &&
          other.cachedAt == this.cachedAt);
}

class CachedSongsCompanion extends UpdateCompanion<CachedSong> {
  final Value<String> songId;
  final Value<String> query;
  final Value<String> title;
  final Value<String> artist;
  final Value<String?> coverUrl;
  final Value<String?> audioUrl;
  final Value<int> durationMs;
  final Value<String?> genre;
  final Value<int> position;
  final Value<int> cachedAt;
  final Value<int> rowid;
  const CachedSongsCompanion({
    this.songId = const Value.absent(),
    this.query = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.genre = const Value.absent(),
    this.position = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSongsCompanion.insert({
    required String songId,
    required String query,
    required String title,
    required String artist,
    this.coverUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.genre = const Value.absent(),
    this.position = const Value.absent(),
    required int cachedAt,
    this.rowid = const Value.absent(),
  }) : songId = Value(songId),
       query = Value(query),
       title = Value(title),
       artist = Value(artist),
       cachedAt = Value(cachedAt);
  static Insertable<CachedSong> custom({
    Expression<String>? songId,
    Expression<String>? query,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? coverUrl,
    Expression<String>? audioUrl,
    Expression<int>? durationMs,
    Expression<String>? genre,
    Expression<int>? position,
    Expression<int>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (songId != null) 'song_id': songId,
      if (query != null) 'query': query,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (durationMs != null) 'duration_ms': durationMs,
      if (genre != null) 'genre': genre,
      if (position != null) 'position': position,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSongsCompanion copyWith({
    Value<String>? songId,
    Value<String>? query,
    Value<String>? title,
    Value<String>? artist,
    Value<String?>? coverUrl,
    Value<String?>? audioUrl,
    Value<int>? durationMs,
    Value<String?>? genre,
    Value<int>? position,
    Value<int>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedSongsCompanion(
      songId: songId ?? this.songId,
      query: query ?? this.query,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      coverUrl: coverUrl ?? this.coverUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      durationMs: durationMs ?? this.durationMs,
      genre: genre ?? this.genre,
      position: position ?? this.position,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<int>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSongsCompanion(')
          ..write('songId: $songId, ')
          ..write('query: $query, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('durationMs: $durationMs, ')
          ..write('genre: $genre, ')
          ..write('position: $position, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPlaylistsTable extends CachedPlaylists
    with TableInfo<$CachedPlaylistsTable, CachedPlaylist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shareCodeMeta = const VerificationMeta(
    'shareCode',
  );
  @override
  late final GeneratedColumn<String> shareCode = GeneratedColumn<String>(
    'share_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    coverUrl,
    ownerId,
    shareCode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPlaylist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('share_code')) {
      context.handle(
        _shareCodeMeta,
        shareCode.isAcceptableOrUnknown(data['share_code']!, _shareCodeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedPlaylist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPlaylist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      shareCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedPlaylistsTable createAlias(String alias) {
    return $CachedPlaylistsTable(attachedDatabase, alias);
  }
}

class CachedPlaylist extends DataClass implements Insertable<CachedPlaylist> {
  final String id;
  final String name;
  final String? description;
  final String? coverUrl;
  final String ownerId;
  final String? shareCode;
  final int createdAt;
  final int updatedAt;
  const CachedPlaylist({
    required this.id,
    required this.name,
    this.description,
    this.coverUrl,
    required this.ownerId,
    this.shareCode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    map['owner_id'] = Variable<String>(ownerId);
    if (!nullToAbsent || shareCode != null) {
      map['share_code'] = Variable<String>(shareCode);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CachedPlaylistsCompanion toCompanion(bool nullToAbsent) {
    return CachedPlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      ownerId: Value(ownerId),
      shareCode: shareCode == null && nullToAbsent
          ? const Value.absent()
          : Value(shareCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedPlaylist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPlaylist(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      shareCode: serializer.fromJson<String?>(json['shareCode']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'ownerId': serializer.toJson<String>(ownerId),
      'shareCode': serializer.toJson<String?>(shareCode),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CachedPlaylist copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    String? ownerId,
    Value<String?> shareCode = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => CachedPlaylist(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    ownerId: ownerId ?? this.ownerId,
    shareCode: shareCode.present ? shareCode.value : this.shareCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedPlaylist copyWithCompanion(CachedPlaylistsCompanion data) {
    return CachedPlaylist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      shareCode: data.shareCode.present ? data.shareCode.value : this.shareCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPlaylist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('ownerId: $ownerId, ')
          ..write('shareCode: $shareCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    coverUrl,
    ownerId,
    shareCode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPlaylist &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.coverUrl == this.coverUrl &&
          other.ownerId == this.ownerId &&
          other.shareCode == this.shareCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CachedPlaylistsCompanion extends UpdateCompanion<CachedPlaylist> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> coverUrl;
  final Value<String> ownerId;
  final Value<String?> shareCode;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CachedPlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.shareCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPlaylistsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.coverUrl = const Value.absent(),
    required String ownerId,
    this.shareCode = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedPlaylist> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? coverUrl,
    Expression<String>? ownerId,
    Expression<String>? shareCode,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (ownerId != null) 'owner_id': ownerId,
      if (shareCode != null) 'share_code': shareCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPlaylistsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? coverUrl,
    Value<String>? ownerId,
    Value<String?>? shareCode,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedPlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      ownerId: ownerId ?? this.ownerId,
      shareCode: shareCode ?? this.shareCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (shareCode.present) {
      map['share_code'] = Variable<String>(shareCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('ownerId: $ownerId, ')
          ..write('shareCode: $shareCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPlaylistSongsTable extends CachedPlaylistSongs
    with TableInfo<$CachedPlaylistSongsTable, CachedPlaylistSong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPlaylistSongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    playlistId,
    songId,
    position,
    title,
    artist,
    coverUrl,
    audioUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_playlist_songs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPlaylistSong> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playlistId, songId};
  @override
  CachedPlaylistSong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPlaylistSong(
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}playlist_id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      )!,
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
    );
  }

  @override
  $CachedPlaylistSongsTable createAlias(String alias) {
    return $CachedPlaylistSongsTable(attachedDatabase, alias);
  }
}

class CachedPlaylistSong extends DataClass
    implements Insertable<CachedPlaylistSong> {
  final String playlistId;
  final String songId;
  final int position;
  final String title;
  final String artist;
  final String? coverUrl;
  final String? audioUrl;
  const CachedPlaylistSong({
    required this.playlistId,
    required this.songId,
    required this.position,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.audioUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['playlist_id'] = Variable<String>(playlistId);
    map['song_id'] = Variable<String>(songId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['artist'] = Variable<String>(artist);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    return map;
  }

  CachedPlaylistSongsCompanion toCompanion(bool nullToAbsent) {
    return CachedPlaylistSongsCompanion(
      playlistId: Value(playlistId),
      songId: Value(songId),
      position: Value(position),
      title: Value(title),
      artist: Value(artist),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
    );
  }

  factory CachedPlaylistSong.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPlaylistSong(
      playlistId: serializer.fromJson<String>(json['playlistId']),
      songId: serializer.fromJson<String>(json['songId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playlistId': serializer.toJson<String>(playlistId),
      'songId': serializer.toJson<String>(songId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'audioUrl': serializer.toJson<String?>(audioUrl),
    };
  }

  CachedPlaylistSong copyWith({
    String? playlistId,
    String? songId,
    int? position,
    String? title,
    String? artist,
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
  }) => CachedPlaylistSong(
    playlistId: playlistId ?? this.playlistId,
    songId: songId ?? this.songId,
    position: position ?? this.position,
    title: title ?? this.title,
    artist: artist ?? this.artist,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
  );
  CachedPlaylistSong copyWithCompanion(CachedPlaylistSongsCompanion data) {
    return CachedPlaylistSong(
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      songId: data.songId.present ? data.songId.value : this.songId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPlaylistSong(')
          ..write('playlistId: $playlistId, ')
          ..write('songId: $songId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('audioUrl: $audioUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    playlistId,
    songId,
    position,
    title,
    artist,
    coverUrl,
    audioUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPlaylistSong &&
          other.playlistId == this.playlistId &&
          other.songId == this.songId &&
          other.position == this.position &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.coverUrl == this.coverUrl &&
          other.audioUrl == this.audioUrl);
}

class CachedPlaylistSongsCompanion extends UpdateCompanion<CachedPlaylistSong> {
  final Value<String> playlistId;
  final Value<String> songId;
  final Value<int> position;
  final Value<String> title;
  final Value<String> artist;
  final Value<String?> coverUrl;
  final Value<String?> audioUrl;
  final Value<int> rowid;
  const CachedPlaylistSongsCompanion({
    this.playlistId = const Value.absent(),
    this.songId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPlaylistSongsCompanion.insert({
    required String playlistId,
    required String songId,
    required int position,
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : playlistId = Value(playlistId),
       songId = Value(songId),
       position = Value(position);
  static Insertable<CachedPlaylistSong> custom({
    Expression<String>? playlistId,
    Expression<String>? songId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? coverUrl,
    Expression<String>? audioUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (playlistId != null) 'playlist_id': playlistId,
      if (songId != null) 'song_id': songId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPlaylistSongsCompanion copyWith({
    Value<String>? playlistId,
    Value<String>? songId,
    Value<int>? position,
    Value<String>? title,
    Value<String>? artist,
    Value<String?>? coverUrl,
    Value<String?>? audioUrl,
    Value<int>? rowid,
  }) {
    return CachedPlaylistSongsCompanion(
      playlistId: playlistId ?? this.playlistId,
      songId: songId ?? this.songId,
      position: position ?? this.position,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      coverUrl: coverUrl ?? this.coverUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPlaylistSongsCompanion(')
          ..write('playlistId: $playlistId, ')
          ..write('songId: $songId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayHistoryTable playHistory = $PlayHistoryTable(this);
  late final $SkipsTable skips = $SkipsTable(this);
  late final $SongTransitionsTable songTransitions = $SongTransitionsTable(
    this,
  );
  late final $SongScoresTable songScores = $SongScoresTable(this);
  late final $UserActionsTable userActions = $UserActionsTable(this);
  late final $RadioStationsTable radioStations = $RadioStationsTable(this);
  late final $DownloadedSongsTable downloadedSongs = $DownloadedSongsTable(
    this,
  );
  late final $CachedSongsTable cachedSongs = $CachedSongsTable(this);
  late final $CachedPlaylistsTable cachedPlaylists = $CachedPlaylistsTable(
    this,
  );
  late final $CachedPlaylistSongsTable cachedPlaylistSongs =
      $CachedPlaylistSongsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    playHistory,
    skips,
    songTransitions,
    songScores,
    userActions,
    radioStations,
    downloadedSongs,
    cachedSongs,
    cachedPlaylists,
    cachedPlaylistSongs,
  ];
}

typedef $$PlayHistoryTableCreateCompanionBuilder =
    PlayHistoryCompanion Function({
      Value<int> id,
      required String songId,
      required String songTitle,
      required String songArtist,
      Value<String?> songCoverUrl,
      Value<String?> audioUrl,
      Value<String> source,
      required int playedAt,
    });
typedef $$PlayHistoryTableUpdateCompanionBuilder =
    PlayHistoryCompanion Function({
      Value<int> id,
      Value<String> songId,
      Value<String> songTitle,
      Value<String> songArtist,
      Value<String?> songCoverUrl,
      Value<String?> audioUrl,
      Value<String> source,
      Value<int> playedAt,
    });

class $$PlayHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PlayHistoryTable> {
  $$PlayHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songTitle => $composableBuilder(
    column: $table.songTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songCoverUrl => $composableBuilder(
    column: $table.songCoverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayHistoryTable> {
  $$PlayHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songTitle => $composableBuilder(
    column: $table.songTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songCoverUrl => $composableBuilder(
    column: $table.songCoverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayHistoryTable> {
  $$PlayHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<String> get songTitle =>
      $composableBuilder(column: $table.songTitle, builder: (column) => column);

  GeneratedColumn<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => column,
  );

  GeneratedColumn<String> get songCoverUrl => $composableBuilder(
    column: $table.songCoverUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);
}

class $$PlayHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayHistoryTable,
          PlayHistoryData,
          $$PlayHistoryTableFilterComposer,
          $$PlayHistoryTableOrderingComposer,
          $$PlayHistoryTableAnnotationComposer,
          $$PlayHistoryTableCreateCompanionBuilder,
          $$PlayHistoryTableUpdateCompanionBuilder,
          (
            PlayHistoryData,
            BaseReferences<_$AppDatabase, $PlayHistoryTable, PlayHistoryData>,
          ),
          PlayHistoryData,
          PrefetchHooks Function()
        > {
  $$PlayHistoryTableTableManager(_$AppDatabase db, $PlayHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> songId = const Value.absent(),
                Value<String> songTitle = const Value.absent(),
                Value<String> songArtist = const Value.absent(),
                Value<String?> songCoverUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> playedAt = const Value.absent(),
              }) => PlayHistoryCompanion(
                id: id,
                songId: songId,
                songTitle: songTitle,
                songArtist: songArtist,
                songCoverUrl: songCoverUrl,
                audioUrl: audioUrl,
                source: source,
                playedAt: playedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String songId,
                required String songTitle,
                required String songArtist,
                Value<String?> songCoverUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String> source = const Value.absent(),
                required int playedAt,
              }) => PlayHistoryCompanion.insert(
                id: id,
                songId: songId,
                songTitle: songTitle,
                songArtist: songArtist,
                songCoverUrl: songCoverUrl,
                audioUrl: audioUrl,
                source: source,
                playedAt: playedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayHistoryTable,
      PlayHistoryData,
      $$PlayHistoryTableFilterComposer,
      $$PlayHistoryTableOrderingComposer,
      $$PlayHistoryTableAnnotationComposer,
      $$PlayHistoryTableCreateCompanionBuilder,
      $$PlayHistoryTableUpdateCompanionBuilder,
      (
        PlayHistoryData,
        BaseReferences<_$AppDatabase, $PlayHistoryTable, PlayHistoryData>,
      ),
      PlayHistoryData,
      PrefetchHooks Function()
    >;
typedef $$SkipsTableCreateCompanionBuilder =
    SkipsCompanion Function({
      Value<int> id,
      required String songId,
      required String songTitle,
      required String songArtist,
      required int skippedAt,
      Value<String?> context,
    });
typedef $$SkipsTableUpdateCompanionBuilder =
    SkipsCompanion Function({
      Value<int> id,
      Value<String> songId,
      Value<String> songTitle,
      Value<String> songArtist,
      Value<int> skippedAt,
      Value<String?> context,
    });

class $$SkipsTableFilterComposer extends Composer<_$AppDatabase, $SkipsTable> {
  $$SkipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songTitle => $composableBuilder(
    column: $table.songTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SkipsTableOrderingComposer
    extends Composer<_$AppDatabase, $SkipsTable> {
  $$SkipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songTitle => $composableBuilder(
    column: $table.songTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SkipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkipsTable> {
  $$SkipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<String> get songTitle =>
      $composableBuilder(column: $table.songTitle, builder: (column) => column);

  GeneratedColumn<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => column,
  );

  GeneratedColumn<int> get skippedAt =>
      $composableBuilder(column: $table.skippedAt, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);
}

class $$SkipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SkipsTable,
          Skip,
          $$SkipsTableFilterComposer,
          $$SkipsTableOrderingComposer,
          $$SkipsTableAnnotationComposer,
          $$SkipsTableCreateCompanionBuilder,
          $$SkipsTableUpdateCompanionBuilder,
          (Skip, BaseReferences<_$AppDatabase, $SkipsTable, Skip>),
          Skip,
          PrefetchHooks Function()
        > {
  $$SkipsTableTableManager(_$AppDatabase db, $SkipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> songId = const Value.absent(),
                Value<String> songTitle = const Value.absent(),
                Value<String> songArtist = const Value.absent(),
                Value<int> skippedAt = const Value.absent(),
                Value<String?> context = const Value.absent(),
              }) => SkipsCompanion(
                id: id,
                songId: songId,
                songTitle: songTitle,
                songArtist: songArtist,
                skippedAt: skippedAt,
                context: context,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String songId,
                required String songTitle,
                required String songArtist,
                required int skippedAt,
                Value<String?> context = const Value.absent(),
              }) => SkipsCompanion.insert(
                id: id,
                songId: songId,
                songTitle: songTitle,
                songArtist: songArtist,
                skippedAt: skippedAt,
                context: context,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SkipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SkipsTable,
      Skip,
      $$SkipsTableFilterComposer,
      $$SkipsTableOrderingComposer,
      $$SkipsTableAnnotationComposer,
      $$SkipsTableCreateCompanionBuilder,
      $$SkipsTableUpdateCompanionBuilder,
      (Skip, BaseReferences<_$AppDatabase, $SkipsTable, Skip>),
      Skip,
      PrefetchHooks Function()
    >;
typedef $$SongTransitionsTableCreateCompanionBuilder =
    SongTransitionsCompanion Function({
      required String fromSongId,
      required String toSongId,
      Value<int> count,
      required int lastTransitionAt,
      Value<int> rowid,
    });
typedef $$SongTransitionsTableUpdateCompanionBuilder =
    SongTransitionsCompanion Function({
      Value<String> fromSongId,
      Value<String> toSongId,
      Value<int> count,
      Value<int> lastTransitionAt,
      Value<int> rowid,
    });

class $$SongTransitionsTableFilterComposer
    extends Composer<_$AppDatabase, $SongTransitionsTable> {
  $$SongTransitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fromSongId => $composableBuilder(
    column: $table.fromSongId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toSongId => $composableBuilder(
    column: $table.toSongId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastTransitionAt => $composableBuilder(
    column: $table.lastTransitionAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SongTransitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongTransitionsTable> {
  $$SongTransitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fromSongId => $composableBuilder(
    column: $table.fromSongId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toSongId => $composableBuilder(
    column: $table.toSongId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastTransitionAt => $composableBuilder(
    column: $table.lastTransitionAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SongTransitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongTransitionsTable> {
  $$SongTransitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fromSongId => $composableBuilder(
    column: $table.fromSongId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toSongId =>
      $composableBuilder(column: $table.toSongId, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get lastTransitionAt => $composableBuilder(
    column: $table.lastTransitionAt,
    builder: (column) => column,
  );
}

class $$SongTransitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SongTransitionsTable,
          SongTransition,
          $$SongTransitionsTableFilterComposer,
          $$SongTransitionsTableOrderingComposer,
          $$SongTransitionsTableAnnotationComposer,
          $$SongTransitionsTableCreateCompanionBuilder,
          $$SongTransitionsTableUpdateCompanionBuilder,
          (
            SongTransition,
            BaseReferences<
              _$AppDatabase,
              $SongTransitionsTable,
              SongTransition
            >,
          ),
          SongTransition,
          PrefetchHooks Function()
        > {
  $$SongTransitionsTableTableManager(
    _$AppDatabase db,
    $SongTransitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongTransitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongTransitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongTransitionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fromSongId = const Value.absent(),
                Value<String> toSongId = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> lastTransitionAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SongTransitionsCompanion(
                fromSongId: fromSongId,
                toSongId: toSongId,
                count: count,
                lastTransitionAt: lastTransitionAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fromSongId,
                required String toSongId,
                Value<int> count = const Value.absent(),
                required int lastTransitionAt,
                Value<int> rowid = const Value.absent(),
              }) => SongTransitionsCompanion.insert(
                fromSongId: fromSongId,
                toSongId: toSongId,
                count: count,
                lastTransitionAt: lastTransitionAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SongTransitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SongTransitionsTable,
      SongTransition,
      $$SongTransitionsTableFilterComposer,
      $$SongTransitionsTableOrderingComposer,
      $$SongTransitionsTableAnnotationComposer,
      $$SongTransitionsTableCreateCompanionBuilder,
      $$SongTransitionsTableUpdateCompanionBuilder,
      (
        SongTransition,
        BaseReferences<_$AppDatabase, $SongTransitionsTable, SongTransition>,
      ),
      SongTransition,
      PrefetchHooks Function()
    >;
typedef $$SongScoresTableCreateCompanionBuilder =
    SongScoresCompanion Function({
      required String songId,
      Value<double> score,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$SongScoresTableUpdateCompanionBuilder =
    SongScoresCompanion Function({
      Value<String> songId,
      Value<double> score,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$SongScoresTableFilterComposer
    extends Composer<_$AppDatabase, $SongScoresTable> {
  $$SongScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SongScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $SongScoresTable> {
  $$SongScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SongScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongScoresTable> {
  $$SongScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SongScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SongScoresTable,
          SongScore,
          $$SongScoresTableFilterComposer,
          $$SongScoresTableOrderingComposer,
          $$SongScoresTableAnnotationComposer,
          $$SongScoresTableCreateCompanionBuilder,
          $$SongScoresTableUpdateCompanionBuilder,
          (
            SongScore,
            BaseReferences<_$AppDatabase, $SongScoresTable, SongScore>,
          ),
          SongScore,
          PrefetchHooks Function()
        > {
  $$SongScoresTableTableManager(_$AppDatabase db, $SongScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> songId = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SongScoresCompanion(
                songId: songId,
                score: score,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String songId,
                Value<double> score = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SongScoresCompanion.insert(
                songId: songId,
                score: score,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SongScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SongScoresTable,
      SongScore,
      $$SongScoresTableFilterComposer,
      $$SongScoresTableOrderingComposer,
      $$SongScoresTableAnnotationComposer,
      $$SongScoresTableCreateCompanionBuilder,
      $$SongScoresTableUpdateCompanionBuilder,
      (SongScore, BaseReferences<_$AppDatabase, $SongScoresTable, SongScore>),
      SongScore,
      PrefetchHooks Function()
    >;
typedef $$UserActionsTableCreateCompanionBuilder =
    UserActionsCompanion Function({
      required String songId,
      required String actionType,
      required String songTitle,
      required String songArtist,
      Value<String?> songCoverUrl,
      Value<String?> audioUrl,
      Value<int> durationMs,
      Value<String?> albumName,
      Value<String?> genre,
      required int createdAt,
      Value<bool> syncedToServer,
      Value<int> rowid,
    });
typedef $$UserActionsTableUpdateCompanionBuilder =
    UserActionsCompanion Function({
      Value<String> songId,
      Value<String> actionType,
      Value<String> songTitle,
      Value<String> songArtist,
      Value<String?> songCoverUrl,
      Value<String?> audioUrl,
      Value<int> durationMs,
      Value<String?> albumName,
      Value<String?> genre,
      Value<int> createdAt,
      Value<bool> syncedToServer,
      Value<int> rowid,
    });

class $$UserActionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserActionsTable> {
  $$UserActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songTitle => $composableBuilder(
    column: $table.songTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songCoverUrl => $composableBuilder(
    column: $table.songCoverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumName => $composableBuilder(
    column: $table.albumName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserActionsTable> {
  $$UserActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songTitle => $composableBuilder(
    column: $table.songTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songCoverUrl => $composableBuilder(
    column: $table.songCoverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumName => $composableBuilder(
    column: $table.albumName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserActionsTable> {
  $$UserActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get songTitle =>
      $composableBuilder(column: $table.songTitle, builder: (column) => column);

  GeneratedColumn<String> get songArtist => $composableBuilder(
    column: $table.songArtist,
    builder: (column) => column,
  );

  GeneratedColumn<String> get songCoverUrl => $composableBuilder(
    column: $table.songCoverUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumName =>
      $composableBuilder(column: $table.albumName, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => column,
  );
}

class $$UserActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserActionsTable,
          UserAction,
          $$UserActionsTableFilterComposer,
          $$UserActionsTableOrderingComposer,
          $$UserActionsTableAnnotationComposer,
          $$UserActionsTableCreateCompanionBuilder,
          $$UserActionsTableUpdateCompanionBuilder,
          (
            UserAction,
            BaseReferences<_$AppDatabase, $UserActionsTable, UserAction>,
          ),
          UserAction,
          PrefetchHooks Function()
        > {
  $$UserActionsTableTableManager(_$AppDatabase db, $UserActionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> songId = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String> songTitle = const Value.absent(),
                Value<String> songArtist = const Value.absent(),
                Value<String?> songCoverUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String?> albumName = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<bool> syncedToServer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserActionsCompanion(
                songId: songId,
                actionType: actionType,
                songTitle: songTitle,
                songArtist: songArtist,
                songCoverUrl: songCoverUrl,
                audioUrl: audioUrl,
                durationMs: durationMs,
                albumName: albumName,
                genre: genre,
                createdAt: createdAt,
                syncedToServer: syncedToServer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String songId,
                required String actionType,
                required String songTitle,
                required String songArtist,
                Value<String?> songCoverUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String?> albumName = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                required int createdAt,
                Value<bool> syncedToServer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserActionsCompanion.insert(
                songId: songId,
                actionType: actionType,
                songTitle: songTitle,
                songArtist: songArtist,
                songCoverUrl: songCoverUrl,
                audioUrl: audioUrl,
                durationMs: durationMs,
                albumName: albumName,
                genre: genre,
                createdAt: createdAt,
                syncedToServer: syncedToServer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserActionsTable,
      UserAction,
      $$UserActionsTableFilterComposer,
      $$UserActionsTableOrderingComposer,
      $$UserActionsTableAnnotationComposer,
      $$UserActionsTableCreateCompanionBuilder,
      $$UserActionsTableUpdateCompanionBuilder,
      (
        UserAction,
        BaseReferences<_$AppDatabase, $UserActionsTable, UserAction>,
      ),
      UserAction,
      PrefetchHooks Function()
    >;
typedef $$RadioStationsTableCreateCompanionBuilder =
    RadioStationsCompanion Function({
      required String stationUuid,
      required String actionType,
      Value<String?> name,
      Value<String?> url,
      Value<String?> urlResolved,
      Value<String?> favicon,
      Value<String?> country,
      Value<String?> countrycode,
      Value<String?> language,
      Value<String?> tags,
      Value<int> bitrate,
      Value<int> votes,
      required int createdAt,
      Value<bool> syncedToServer,
      Value<int> rowid,
    });
typedef $$RadioStationsTableUpdateCompanionBuilder =
    RadioStationsCompanion Function({
      Value<String> stationUuid,
      Value<String> actionType,
      Value<String?> name,
      Value<String?> url,
      Value<String?> urlResolved,
      Value<String?> favicon,
      Value<String?> country,
      Value<String?> countrycode,
      Value<String?> language,
      Value<String?> tags,
      Value<int> bitrate,
      Value<int> votes,
      Value<int> createdAt,
      Value<bool> syncedToServer,
      Value<int> rowid,
    });

class $$RadioStationsTableFilterComposer
    extends Composer<_$AppDatabase, $RadioStationsTable> {
  $$RadioStationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stationUuid => $composableBuilder(
    column: $table.stationUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urlResolved => $composableBuilder(
    column: $table.urlResolved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favicon => $composableBuilder(
    column: $table.favicon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countrycode => $composableBuilder(
    column: $table.countrycode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bitrate => $composableBuilder(
    column: $table.bitrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get votes => $composableBuilder(
    column: $table.votes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RadioStationsTableOrderingComposer
    extends Composer<_$AppDatabase, $RadioStationsTable> {
  $$RadioStationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stationUuid => $composableBuilder(
    column: $table.stationUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urlResolved => $composableBuilder(
    column: $table.urlResolved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favicon => $composableBuilder(
    column: $table.favicon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countrycode => $composableBuilder(
    column: $table.countrycode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bitrate => $composableBuilder(
    column: $table.bitrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get votes => $composableBuilder(
    column: $table.votes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RadioStationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RadioStationsTable> {
  $$RadioStationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stationUuid => $composableBuilder(
    column: $table.stationUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get urlResolved => $composableBuilder(
    column: $table.urlResolved,
    builder: (column) => column,
  );

  GeneratedColumn<String> get favicon =>
      $composableBuilder(column: $table.favicon, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get countrycode => $composableBuilder(
    column: $table.countrycode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get bitrate =>
      $composableBuilder(column: $table.bitrate, builder: (column) => column);

  GeneratedColumn<int> get votes =>
      $composableBuilder(column: $table.votes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get syncedToServer => $composableBuilder(
    column: $table.syncedToServer,
    builder: (column) => column,
  );
}

class $$RadioStationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RadioStationsTable,
          RadioStation,
          $$RadioStationsTableFilterComposer,
          $$RadioStationsTableOrderingComposer,
          $$RadioStationsTableAnnotationComposer,
          $$RadioStationsTableCreateCompanionBuilder,
          $$RadioStationsTableUpdateCompanionBuilder,
          (
            RadioStation,
            BaseReferences<_$AppDatabase, $RadioStationsTable, RadioStation>,
          ),
          RadioStation,
          PrefetchHooks Function()
        > {
  $$RadioStationsTableTableManager(_$AppDatabase db, $RadioStationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RadioStationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadioStationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadioStationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> stationUuid = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> urlResolved = const Value.absent(),
                Value<String?> favicon = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> countrycode = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> bitrate = const Value.absent(),
                Value<int> votes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<bool> syncedToServer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RadioStationsCompanion(
                stationUuid: stationUuid,
                actionType: actionType,
                name: name,
                url: url,
                urlResolved: urlResolved,
                favicon: favicon,
                country: country,
                countrycode: countrycode,
                language: language,
                tags: tags,
                bitrate: bitrate,
                votes: votes,
                createdAt: createdAt,
                syncedToServer: syncedToServer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String stationUuid,
                required String actionType,
                Value<String?> name = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> urlResolved = const Value.absent(),
                Value<String?> favicon = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> countrycode = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> bitrate = const Value.absent(),
                Value<int> votes = const Value.absent(),
                required int createdAt,
                Value<bool> syncedToServer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RadioStationsCompanion.insert(
                stationUuid: stationUuid,
                actionType: actionType,
                name: name,
                url: url,
                urlResolved: urlResolved,
                favicon: favicon,
                country: country,
                countrycode: countrycode,
                language: language,
                tags: tags,
                bitrate: bitrate,
                votes: votes,
                createdAt: createdAt,
                syncedToServer: syncedToServer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RadioStationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RadioStationsTable,
      RadioStation,
      $$RadioStationsTableFilterComposer,
      $$RadioStationsTableOrderingComposer,
      $$RadioStationsTableAnnotationComposer,
      $$RadioStationsTableCreateCompanionBuilder,
      $$RadioStationsTableUpdateCompanionBuilder,
      (
        RadioStation,
        BaseReferences<_$AppDatabase, $RadioStationsTable, RadioStation>,
      ),
      RadioStation,
      PrefetchHooks Function()
    >;
typedef $$DownloadedSongsTableCreateCompanionBuilder =
    DownloadedSongsCompanion Function({
      required String songId,
      required String title,
      required String artist,
      Value<String?> coverUrl,
      required String localFilePath,
      Value<int> fileSize,
      required int downloadedAt,
      Value<int> rowid,
    });
typedef $$DownloadedSongsTableUpdateCompanionBuilder =
    DownloadedSongsCompanion Function({
      Value<String> songId,
      Value<String> title,
      Value<String> artist,
      Value<String?> coverUrl,
      Value<String> localFilePath,
      Value<int> fileSize,
      Value<int> downloadedAt,
      Value<int> rowid,
    });

class $$DownloadedSongsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedSongsTable> {
  $$DownloadedSongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DownloadedSongsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedSongsTable> {
  $$DownloadedSongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadedSongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedSongsTable> {
  $$DownloadedSongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );
}

class $$DownloadedSongsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadedSongsTable,
          DownloadedSong,
          $$DownloadedSongsTableFilterComposer,
          $$DownloadedSongsTableOrderingComposer,
          $$DownloadedSongsTableAnnotationComposer,
          $$DownloadedSongsTableCreateCompanionBuilder,
          $$DownloadedSongsTableUpdateCompanionBuilder,
          (
            DownloadedSong,
            BaseReferences<
              _$AppDatabase,
              $DownloadedSongsTable,
              DownloadedSong
            >,
          ),
          DownloadedSong,
          PrefetchHooks Function()
        > {
  $$DownloadedSongsTableTableManager(
    _$AppDatabase db,
    $DownloadedSongsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedSongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedSongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedSongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> songId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String> localFilePath = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<int> downloadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadedSongsCompanion(
                songId: songId,
                title: title,
                artist: artist,
                coverUrl: coverUrl,
                localFilePath: localFilePath,
                fileSize: fileSize,
                downloadedAt: downloadedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String songId,
                required String title,
                required String artist,
                Value<String?> coverUrl = const Value.absent(),
                required String localFilePath,
                Value<int> fileSize = const Value.absent(),
                required int downloadedAt,
                Value<int> rowid = const Value.absent(),
              }) => DownloadedSongsCompanion.insert(
                songId: songId,
                title: title,
                artist: artist,
                coverUrl: coverUrl,
                localFilePath: localFilePath,
                fileSize: fileSize,
                downloadedAt: downloadedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadedSongsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadedSongsTable,
      DownloadedSong,
      $$DownloadedSongsTableFilterComposer,
      $$DownloadedSongsTableOrderingComposer,
      $$DownloadedSongsTableAnnotationComposer,
      $$DownloadedSongsTableCreateCompanionBuilder,
      $$DownloadedSongsTableUpdateCompanionBuilder,
      (
        DownloadedSong,
        BaseReferences<_$AppDatabase, $DownloadedSongsTable, DownloadedSong>,
      ),
      DownloadedSong,
      PrefetchHooks Function()
    >;
typedef $$CachedSongsTableCreateCompanionBuilder =
    CachedSongsCompanion Function({
      required String songId,
      required String query,
      required String title,
      required String artist,
      Value<String?> coverUrl,
      Value<String?> audioUrl,
      Value<int> durationMs,
      Value<String?> genre,
      Value<int> position,
      required int cachedAt,
      Value<int> rowid,
    });
typedef $$CachedSongsTableUpdateCompanionBuilder =
    CachedSongsCompanion Function({
      Value<String> songId,
      Value<String> query,
      Value<String> title,
      Value<String> artist,
      Value<String?> coverUrl,
      Value<String?> audioUrl,
      Value<int> durationMs,
      Value<String?> genre,
      Value<int> position,
      Value<int> cachedAt,
      Value<int> rowid,
    });

class $$CachedSongsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSongsTable> {
  $$CachedSongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSongsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSongsTable> {
  $$CachedSongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSongsTable> {
  $$CachedSongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedSongsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSongsTable,
          CachedSong,
          $$CachedSongsTableFilterComposer,
          $$CachedSongsTableOrderingComposer,
          $$CachedSongsTableAnnotationComposer,
          $$CachedSongsTableCreateCompanionBuilder,
          $$CachedSongsTableUpdateCompanionBuilder,
          (
            CachedSong,
            BaseReferences<_$AppDatabase, $CachedSongsTable, CachedSong>,
          ),
          CachedSong,
          PrefetchHooks Function()
        > {
  $$CachedSongsTableTableManager(_$AppDatabase db, $CachedSongsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> songId = const Value.absent(),
                Value<String> query = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSongsCompanion(
                songId: songId,
                query: query,
                title: title,
                artist: artist,
                coverUrl: coverUrl,
                audioUrl: audioUrl,
                durationMs: durationMs,
                genre: genre,
                position: position,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String songId,
                required String query,
                required String title,
                required String artist,
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int> position = const Value.absent(),
                required int cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedSongsCompanion.insert(
                songId: songId,
                query: query,
                title: title,
                artist: artist,
                coverUrl: coverUrl,
                audioUrl: audioUrl,
                durationMs: durationMs,
                genre: genre,
                position: position,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSongsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSongsTable,
      CachedSong,
      $$CachedSongsTableFilterComposer,
      $$CachedSongsTableOrderingComposer,
      $$CachedSongsTableAnnotationComposer,
      $$CachedSongsTableCreateCompanionBuilder,
      $$CachedSongsTableUpdateCompanionBuilder,
      (
        CachedSong,
        BaseReferences<_$AppDatabase, $CachedSongsTable, CachedSong>,
      ),
      CachedSong,
      PrefetchHooks Function()
    >;
typedef $$CachedPlaylistsTableCreateCompanionBuilder =
    CachedPlaylistsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String?> coverUrl,
      required String ownerId,
      Value<String?> shareCode,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CachedPlaylistsTableUpdateCompanionBuilder =
    CachedPlaylistsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> coverUrl,
      Value<String> ownerId,
      Value<String?> shareCode,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$CachedPlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPlaylistsTable> {
  $$CachedPlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shareCode => $composableBuilder(
    column: $table.shareCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPlaylistsTable> {
  $$CachedPlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareCode => $composableBuilder(
    column: $table.shareCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPlaylistsTable> {
  $$CachedPlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get shareCode =>
      $composableBuilder(column: $table.shareCode, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedPlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedPlaylistsTable,
          CachedPlaylist,
          $$CachedPlaylistsTableFilterComposer,
          $$CachedPlaylistsTableOrderingComposer,
          $$CachedPlaylistsTableAnnotationComposer,
          $$CachedPlaylistsTableCreateCompanionBuilder,
          $$CachedPlaylistsTableUpdateCompanionBuilder,
          (
            CachedPlaylist,
            BaseReferences<
              _$AppDatabase,
              $CachedPlaylistsTable,
              CachedPlaylist
            >,
          ),
          CachedPlaylist,
          PrefetchHooks Function()
        > {
  $$CachedPlaylistsTableTableManager(
    _$AppDatabase db,
    $CachedPlaylistsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String?> shareCode = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPlaylistsCompanion(
                id: id,
                name: name,
                description: description,
                coverUrl: coverUrl,
                ownerId: ownerId,
                shareCode: shareCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                required String ownerId,
                Value<String?> shareCode = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedPlaylistsCompanion.insert(
                id: id,
                name: name,
                description: description,
                coverUrl: coverUrl,
                ownerId: ownerId,
                shareCode: shareCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedPlaylistsTable,
      CachedPlaylist,
      $$CachedPlaylistsTableFilterComposer,
      $$CachedPlaylistsTableOrderingComposer,
      $$CachedPlaylistsTableAnnotationComposer,
      $$CachedPlaylistsTableCreateCompanionBuilder,
      $$CachedPlaylistsTableUpdateCompanionBuilder,
      (
        CachedPlaylist,
        BaseReferences<_$AppDatabase, $CachedPlaylistsTable, CachedPlaylist>,
      ),
      CachedPlaylist,
      PrefetchHooks Function()
    >;
typedef $$CachedPlaylistSongsTableCreateCompanionBuilder =
    CachedPlaylistSongsCompanion Function({
      required String playlistId,
      required String songId,
      required int position,
      Value<String> title,
      Value<String> artist,
      Value<String?> coverUrl,
      Value<String?> audioUrl,
      Value<int> rowid,
    });
typedef $$CachedPlaylistSongsTableUpdateCompanionBuilder =
    CachedPlaylistSongsCompanion Function({
      Value<String> playlistId,
      Value<String> songId,
      Value<int> position,
      Value<String> title,
      Value<String> artist,
      Value<String?> coverUrl,
      Value<String?> audioUrl,
      Value<int> rowid,
    });

class $$CachedPlaylistSongsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPlaylistSongsTable> {
  $$CachedPlaylistSongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPlaylistSongsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPlaylistSongsTable> {
  $$CachedPlaylistSongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get songId => $composableBuilder(
    column: $table.songId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPlaylistSongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPlaylistSongsTable> {
  $$CachedPlaylistSongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);
}

class $$CachedPlaylistSongsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedPlaylistSongsTable,
          CachedPlaylistSong,
          $$CachedPlaylistSongsTableFilterComposer,
          $$CachedPlaylistSongsTableOrderingComposer,
          $$CachedPlaylistSongsTableAnnotationComposer,
          $$CachedPlaylistSongsTableCreateCompanionBuilder,
          $$CachedPlaylistSongsTableUpdateCompanionBuilder,
          (
            CachedPlaylistSong,
            BaseReferences<
              _$AppDatabase,
              $CachedPlaylistSongsTable,
              CachedPlaylistSong
            >,
          ),
          CachedPlaylistSong,
          PrefetchHooks Function()
        > {
  $$CachedPlaylistSongsTableTableManager(
    _$AppDatabase db,
    $CachedPlaylistSongsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPlaylistSongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPlaylistSongsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedPlaylistSongsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> playlistId = const Value.absent(),
                Value<String> songId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPlaylistSongsCompanion(
                playlistId: playlistId,
                songId: songId,
                position: position,
                title: title,
                artist: artist,
                coverUrl: coverUrl,
                audioUrl: audioUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String playlistId,
                required String songId,
                required int position,
                Value<String> title = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPlaylistSongsCompanion.insert(
                playlistId: playlistId,
                songId: songId,
                position: position,
                title: title,
                artist: artist,
                coverUrl: coverUrl,
                audioUrl: audioUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPlaylistSongsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedPlaylistSongsTable,
      CachedPlaylistSong,
      $$CachedPlaylistSongsTableFilterComposer,
      $$CachedPlaylistSongsTableOrderingComposer,
      $$CachedPlaylistSongsTableAnnotationComposer,
      $$CachedPlaylistSongsTableCreateCompanionBuilder,
      $$CachedPlaylistSongsTableUpdateCompanionBuilder,
      (
        CachedPlaylistSong,
        BaseReferences<
          _$AppDatabase,
          $CachedPlaylistSongsTable,
          CachedPlaylistSong
        >,
      ),
      CachedPlaylistSong,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayHistoryTableTableManager get playHistory =>
      $$PlayHistoryTableTableManager(_db, _db.playHistory);
  $$SkipsTableTableManager get skips =>
      $$SkipsTableTableManager(_db, _db.skips);
  $$SongTransitionsTableTableManager get songTransitions =>
      $$SongTransitionsTableTableManager(_db, _db.songTransitions);
  $$SongScoresTableTableManager get songScores =>
      $$SongScoresTableTableManager(_db, _db.songScores);
  $$UserActionsTableTableManager get userActions =>
      $$UserActionsTableTableManager(_db, _db.userActions);
  $$RadioStationsTableTableManager get radioStations =>
      $$RadioStationsTableTableManager(_db, _db.radioStations);
  $$DownloadedSongsTableTableManager get downloadedSongs =>
      $$DownloadedSongsTableTableManager(_db, _db.downloadedSongs);
  $$CachedSongsTableTableManager get cachedSongs =>
      $$CachedSongsTableTableManager(_db, _db.cachedSongs);
  $$CachedPlaylistsTableTableManager get cachedPlaylists =>
      $$CachedPlaylistsTableTableManager(_db, _db.cachedPlaylists);
  $$CachedPlaylistSongsTableTableManager get cachedPlaylistSongs =>
      $$CachedPlaylistSongsTableTableManager(_db, _db.cachedPlaylistSongs);
}
