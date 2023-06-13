<?php
$validated = $validator->safe()->all();
$user = $request->user();

// $book可以获取函数内的返回结果
$book = DB::transaction(fn() => Book::create([
    'user_id' => $user->id,
    ...$validated,
])->users()->attach($user->id));

